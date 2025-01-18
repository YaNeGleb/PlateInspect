//
//  ModuleBuilder.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 13.01.2025.
//

import UIKit

struct ModuleBuilder {
    static func createMainScreen(carService: CarServiceProtocol) -> CarViewController {
        let carService = CarService()
        let carViewModel = CarViewModel(carService: carService)
        let carViewController = CarViewController(viewModel: carViewModel)
        return carViewController
    }
    
    static func createDetailCarScreen(carInfo: CarInfo) -> CarDetailViewController {
        let carDetailViewModel = CarDetailViewModel(carInfo: carInfo)
        let carDetailVC = CarDetailViewController(viewModel: carDetailViewModel)
        return carDetailVC
    }
}
