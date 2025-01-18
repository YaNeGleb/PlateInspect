//
//  CarServiceProtocol.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import Foundation
import RxSwift

protocol CarServiceProtocol {
    func fetchCarInfo(by plate: String) -> Observable<CarInfo>
}
