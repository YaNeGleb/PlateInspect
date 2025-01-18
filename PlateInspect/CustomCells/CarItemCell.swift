//
//  CarItemCell.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import UIKit
import SDWebImage

class CarItemCell: UITableViewCell {
    
    static let identifier = "CarItemCell"

    @IBOutlet weak var carTitle: UILabel!
    @IBOutlet weak var carPlate: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carColor: UILabel!
    
    func configureCell(with car: CarInfo) {
        let operations = car.operations.first
        let vendor = operations?.vendor ?? ""
        let model = operations?.model ?? ""
        let color = operations?.color.slug ?? ""
        
        carTitle.text = vendor + " " + model
        carPlate.text = car.digits
        carColor.text = "Color: \(color)".uppercased()
        
        loadCarImage(urlString: car.photoURL ?? "")
    }
    
    private func loadCarImage(urlString: String) {
        let url = URL(string: urlString)
        let image = UIImage(systemName: "xmark.icloud")
        carImage.image = image
        carImage.sd_setImage(with: url, placeholderImage: image, options: .highPriority) { image, error, cacheType, url in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else {
                print("Image loaded")
            }
        }
    }

}
