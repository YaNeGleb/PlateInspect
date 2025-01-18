//
//  CarViewModelProtocol.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import Foundation
import RxCocoa

protocol CarViewModelProtocol {
    var carInfo: Driver<CarInfo?> { get }
    var isLoading: Driver<Bool> { get }
    var historyCars: Driver<[CarInfo]> { get }
    var error: Driver<String> { get }
    func fetchCarInfo(plate: String)
    func createDetailScreen(car: CarInfo) -> CarDetailViewController
    func saveCarToHistory(carInfo: CarInfo)
    func onAppear()
}
