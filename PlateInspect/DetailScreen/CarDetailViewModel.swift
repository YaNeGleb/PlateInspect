//
//  CarDetailViewModel.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 13.01.2025.
//

import Foundation

class CarDetailViewModel: DetailCarViewModelProtocol {
    let carInfo: CarInfo
    var details: [(String, String, String)] = []
    
    init(carInfo: CarInfo) {
        self.carInfo = carInfo
        self.details = prepareDetails(from: carInfo)
    }
    
    private func prepareDetails(from carInfo: CarInfo) -> [(String, String, String)] {
        let firstOperation = carInfo.operations.first
        return [
            ("🌍", "Region", carInfo.region.name),
            ("📅", "Date Registered", firstOperation?.registeredAt ?? "No info"),
            ("🏢", "Department", firstOperation?.department ?? "No info"),
            ("🏠", "Address", firstOperation?.address ?? "No info"),
            ("🔄", "Last Operation", firstOperation?.operation.ru ?? "No info"),
            ("🚗", "VIN", carInfo.vin ?? "No info"),
            ("🏢", "Registered To Company", registeredToCompanyText(firstOperation)),
            ("🚗", "Type", firstOperation?.kind.slug ?? "No info")
        ]
    }
    
    private func registeredToCompanyText(_ firstOperation: OperationElement?) -> String {
        guard let isRegistered = firstOperation?.isRegisteredToCompany else { return "No info" }
        return isRegistered ? "Yes" : "No"
    }
}
