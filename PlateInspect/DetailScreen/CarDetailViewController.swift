//
//  CarDetailViewController.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import UIKit
import SDWebImage

class CarDetailViewController: UIViewController {
    
    private let viewModel: DetailCarViewModelProtocol
    
    private let carImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let carTitleLabel: UILabel = {
        let carTitleLabel = UILabel()
        carTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        carTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        carTitleLabel.numberOfLines = 0
        return carTitleLabel
    }()
    private let sectionTitleLabel: UILabel = {
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionTitleLabel.text = "Parameters:"
        sectionTitleLabel.textColor = .gray
        sectionTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return sectionTitleLabel
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let detailContainer: UIView = {
        let detailContainer = UIView()
        detailContainer.translatesAutoresizingMaskIntoConstraints = false
        detailContainer.layer.cornerRadius = 15
        detailContainer.layer.masksToBounds = true
        detailContainer.backgroundColor = UIColor(named: "mainColor2")
        return detailContainer
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let separator : UIView = {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    private let detailStackView : UIStackView = {
        let detailStackView = UIStackView()
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
        detailStackView.spacing = 18
        detailStackView.alignment = .fill
        return detailStackView
    }()
  
    init(viewModel: DetailCarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        navigationItem.title = viewModel.carInfo.digits
        self.navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = UIColor(named: "secondaryColor")
        view.addSubview(scrollView)
        
        scrollView.addSubview(carImageView)
        scrollView.addSubview(detailContainer)
        
        detailContainer.addSubview(carTitleLabel)
        detailContainer.addSubview(sectionTitleLabel)
        detailContainer.addSubview(stackView)
        detailContainer.addSubview(separator)
        detailContainer.addSubview(detailStackView)
    }
    
    private func configureData() {
        let car = viewModel.carInfo
        carTitleLabel.text = car.vendor + " " + car.model
        loadCarImage(urlString: viewModel.carInfo.photoURL ?? "")

        configureTopStackView()
        configureDetailsStackView()
    }
    
    private func configureTopStackView() {
        let color = viewModel.carInfo.operations.first?.color.slug ?? "No info"
        let colorContainer = createVerticalStackView(
            withEmodji: "🎨",
            title: "Color",
            subtitle: color
        )
        
        let yearContainer = createVerticalStackView(
            withEmodji: "📅",
            title: "Year",
            subtitle: String(viewModel.carInfo.modelYear)
        )
        
        let stolenContainer = createVerticalStackView(
            withEmodji: "🛡️",
            title: "Stolen",
            subtitle: viewModel.carInfo.isStolen ? "Yes" : "No"
        )
        
        stackView.addArrangedSubview(colorContainer)
        stackView.addArrangedSubview(yearContainer)
        stackView.addArrangedSubview(stolenContainer)
    }
    
    private func configureDetailsStackView() {
        viewModel.details.forEach { emodji, title, subtitle in
            let container = createDetailedContainer(emodji: emodji, title: title, subtitle: subtitle)
            detailStackView.addArrangedSubview(container)
        }
        
        detailContainer.addSubview(detailStackView)
    }
    
    private func loadCarImage(urlString: String) {
        let url = URL(string: urlString)
        let image = UIImage(systemName: "xmark.icloud")
        carImageView.sd_setImage(with: url,
                                 placeholderImage: image,
                                 options: .highPriority) { image, error, cacheType, url in
            if let error = error {
                print("Image loaded: \(error.localizedDescription)")
            } else {
                print("Error loading image")
            }
        }
    }

    
    private func createVerticalStackView(withEmodji emodji: String, title: String, subtitle: String) -> UIView {
        let emodjiLabel = UILabel()
        emodjiLabel.translatesAutoresizingMaskIntoConstraints = false
        emodjiLabel.text = emodji
        emodjiLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = .gray
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle.uppercased()
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        subtitleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [emodjiLabel, titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        return stackView
    }
    
    private func createDetailedContainer(
        emodji: String,
        title: String,
        subtitle: String) -> UIView {
            
            let emodjiView = UILabel()
            emodjiView.translatesAutoresizingMaskIntoConstraints = false
            emodjiView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            emodjiView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            emodjiView.text = emodji
            
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.numberOfLines = 1
            
            let subtitleLabel = UILabel()
            subtitleLabel.text = subtitle
            subtitleLabel.font = UIFont.systemFont(ofSize: 14)
            subtitleLabel.textColor = .gray
            subtitleLabel.numberOfLines = 0
            
            let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            textStackView.axis = .vertical
            textStackView.spacing = 4
            textStackView.alignment = .leading
            
            let horizontalStackView = UIStackView(arrangedSubviews: [emodjiView, textStackView])
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 12
            horizontalStackView.alignment = .center
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            
            return horizontalStackView
        }
}


extension CarDetailViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            // CarImageView Constraints
            carImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            carImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            carImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // DetailContainer Constraints
            detailContainer.topAnchor.constraint(equalTo: carImageView.bottomAnchor,
                                                 constant: 70),
            detailContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            detailContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                    constant: -20),
            
            // CarTitleLabel Constraints
            carTitleLabel.topAnchor.constraint(equalTo: detailContainer.topAnchor, constant: 20),
            carTitleLabel.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 20),
            carTitleLabel.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -20),
            
            // SectionTitleLabel Constraints
            sectionTitleLabel.topAnchor.constraint(equalTo: carTitleLabel.bottomAnchor, constant: 25),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 20),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -20),
            
            // StackView Constraints
            stackView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -30),
            
            // Separator Constraints
            separator.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            // DetailStackView Constraints
            detailStackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            detailStackView.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor, constant: 20),
            detailStackView.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -20),
            detailStackView.bottomAnchor.constraint(equalTo: detailContainer.bottomAnchor, constant: -20)
        ])
    }
}

