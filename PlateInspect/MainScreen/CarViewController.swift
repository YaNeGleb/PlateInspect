//
//  CarViewController.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

class CarViewController: UIViewController {
    private let viewModel: CarViewModelProtocol
    private let disposeBag = DisposeBag()

    private let plateTextField: UITextField = {
        let textField = UITextField()
        let placeHolder = "KE 1111 HT"
        textField.placeholder = placeHolder
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.autocapitalizationType = .allCharacters
        textField.textColor = .darkGray
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: placeholderAttributes)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let fetchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                        for: .normal)
        button.tintColor = .black
        button.backgroundColor = .gray
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 200
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        let nib = UINib(nibName: CarItemCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CarItemCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    private lazy var spinner: CustomSpinnerSimple = {
        let spinner = CustomSpinnerSimple(squareLength: 100)
        return spinner
    }()

    init(viewModel: CarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onAppear()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "secondaryColor")
        navigationItem.title = "Search"
        view.addSubview(plateTextField)
        view.addSubview(fetchButton)
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            plateTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            plateTextField.heightAnchor.constraint(equalToConstant: 40),
            plateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            plateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)
        ])

        NSLayoutConstraint.activate([
            fetchButton.centerYAnchor.constraint(equalTo: plateTextField.centerYAnchor),
            fetchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            fetchButton.heightAnchor.constraint(equalToConstant: 50),
            fetchButton.widthAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: plateTextField.topAnchor, constant: -15)
        ])
    }
    
    private func setupActions() {
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
    }
    
    @objc private func fetchButtonTapped() {
        guard let plateNumber  = plateTextField.text else {
            print("Textfield is empty")
            return
        }
        viewModel.fetchCarInfo(plate: plateNumber)
    }

    private func bindViewModel() {
        fetchButton.rx.tap
            .withLatestFrom(plateTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] plate in
                self?.viewModel.fetchCarInfo(plate: plate)
            })
            .disposed(by: disposeBag)
        
        viewModel.carInfo
            .distinctUntilChanged()
            .compactMap { $0 }
            .drive(onNext: { [weak self] carInfo in
                self?.viewModel.saveCarToHistory(carInfo: carInfo)
                self?.navigateToCarDetail(carInfo: carInfo)
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .drive(onNext: { [weak self] errorMessage in
                self?.showError(message: errorMessage)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.spinner.isHidden = !isLoading
                isLoading ? self?.spinner.startAnimation(delay: 0.01, replicates: 120) : self?.spinner.stopAnimation()
            })
            .disposed(by: disposeBag)
        
        viewModel.historyCars
            .drive(tableView.rx.items(cellIdentifier: CarItemCell.identifier, cellType: CarItemCell.self)) { _, carInfo, cell in
                cell.configureCell(with: carInfo)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CarInfo.self)
            .subscribe(onNext: { [weak self] carInfo in
                self?.navigateToCarDetail(carInfo: carInfo)
            })
            .disposed(by: disposeBag)
        
        plateTextField.rx.text.orEmpty
            .map { $0.filter { $0.isLetter || $0.isNumber }.uppercased() }
            .bind(to: plateTextField.rx.text)
            .disposed(by: disposeBag)
    }

    
    private func navigateToCarDetail(carInfo: CarInfo) {
        let carDetailVC = viewModel.createDetailScreen(car: carInfo)
        self.navigationController?.pushViewController(carDetailVC, animated: true)
    }
    
    private func showError(message: String) {
        let alert = PopupErrorViewController(errorTitle: "ERROR", errorMessage: message)
        self.present(alert, animated: true)
    }
}

