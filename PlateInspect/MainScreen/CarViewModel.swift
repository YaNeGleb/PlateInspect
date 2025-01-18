//
//  CarViewModel.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import Foundation
import RxSwift
import RxCocoa

class CarViewModel: CarViewModelProtocol {
    private let carService: CarServiceProtocol
    private let disposeBag = DisposeBag()
    
    let carInfo: Driver<CarInfo?>
    let isLoading: Driver<Bool>
    let historyCars: Driver<[CarInfo]>
    let error: Driver<String>
    
    private let carInfoRelay = BehaviorRelay<CarInfo?>(value: nil)
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let historyRelay = BehaviorRelay<[CarInfo]>(value: [])
    private let errorRelay = PublishRelay<String>()
    
    init(carService: CarServiceProtocol) {
        self.carService = carService
        
        self.carInfo = carInfoRelay.asDriver(onErrorJustReturn: nil)
        self.isLoading = loadingRelay.asDriver(onErrorJustReturn: false)
        self.historyCars = historyRelay.asDriver(onErrorJustReturn: [])
        self.error = errorRelay.asDriver(onErrorJustReturn: "")
    }
    
    func fetchCarInfo(plate: String) {
        setLoading(true)
        
        carService.fetchCarInfo(by: plate)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] car in
                    self?.setLoading(false)
                    self?.carInfoRelay.accept(car)
                },
                onError: { [weak self] error in
                    self?.setLoading(false)
                    self?.handleError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setLoading(_ isLoading: Bool) {
        loadingRelay.accept(isLoading)
    }
    
    private func handleError(_ error: Error) {
        errorRelay.accept(error.localizedDescription)
    }
    
    func onAppear() {
        let history = fetchHistoryFromCoreData()
        historyRelay.accept(history)
    }
    
    private func fetchHistoryFromCoreData() -> [CarInfo] {
        return CoreDataManager.shared.fetchCustomStructs()
    }
    
    func saveCarToHistory(carInfo: CarInfo) {
        CoreDataManager.shared.saveCustomStruct(carInfo)
    }
    
    func createDetailScreen(car: CarInfo) -> CarDetailViewController {
        return ModuleBuilder.createDetailCarScreen(carInfo: car)
    }
}


