//
//  CarService.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import Foundation
import RxSwift

class CarService: CarServiceProtocol {
    private let baseURL = "https://baza-gai.com.ua/nomer/"
    private let apiKey = "a4ab80681df29253ccac2f08ac918b99"
    
    enum CarServiceError: Error {
        case invalidURL
        case noData
        case decodingError
        case networkError(Error)
    }
    
    private func makeRequest(for plate: String) -> URLRequest? {
        guard let url = URL(string: baseURL + plate) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        return request
    }
    
    private func parseResponse(data: Data) -> Result<CarInfo, CarServiceError> {
        do {
            let carInfo = try JSONDecoder().decode(CarInfo.self, from: data)
            return .success(carInfo)
        } catch {
            return .failure(.decodingError)
        }
    }
    
    func fetchCarInfo(by plate: String) -> Observable<CarInfo> {
        guard let request = makeRequest(for: plate) else {
            return Observable.error(CarServiceError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: request)
            .map { [weak self] data in
                return self?.parseResponse(data: data)
            }
            .flatMap { result -> Observable<CarInfo> in
                switch result {
                case .success(let carInfo):
                    return Observable.just(carInfo)
                case .failure(let error):
                    return Observable.error(error)
                case .none:
                    return Observable.error(CarServiceError.noData)
                }
            }
            .take(1)
    }
}



