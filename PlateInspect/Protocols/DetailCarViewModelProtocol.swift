//
//  DetailCarViewModelProtocol.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 13.01.2025.
//

import Foundation

protocol DetailCarViewModelProtocol {
    var carInfo: CarInfo { get }
    var details: [(String, String, String)] { get }
}
