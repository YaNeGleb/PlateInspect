//
//  PopupErrorViewController.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 13.01.2025.
//

import UIKit

class PopupErrorViewController: UIViewController {
    static let controllerIdentifier = String(describing: PopupErrorViewController.self)
    
    var errorTitle: String = "Error"
    var errorMessage: String = "Error Message"
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var alertContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertContainerView.layer.cornerRadius = 8.0
        alertContainerView.backgroundColor = .white
        alertContainerView.clipsToBounds = true

        self.errorTitleLabel.text = "\(errorTitle)"
        self.errorMessageLabel.text = errorMessage
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(errorTitle: String, errorMessage: String) {
        super.init(nibName: PopupErrorViewController.controllerIdentifier, bundle: Bundle(for: PopupErrorViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func onCloseButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
