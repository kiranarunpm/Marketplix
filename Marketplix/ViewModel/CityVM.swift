//
//  CityVM.swift
//  Marketplix
//
//  Created by Kiran P M on 11/08/23.
//

import Foundation

class CityVM{
    public var successClosure: (() -> ())?
    public var failureClosure:(() -> ())?
    public var loadingStatus:(() -> ())?
    
    public var cityArr: [City] = [] {
        didSet{
            self.successClosure?()
        }
    }
    
    public var filterArr: [Flter] = [] {
        didSet{
            self.successClosure?()
        }
    }
    
    public var alertMessage: String? {
        didSet{
            self.failureClosure?()
        }
    }
    
    public var isLoading:Bool? {
        didSet{
            self.loadingStatus?()
        }
    }
}


extension CityVM {
    
    func callCityNames(filename fileName: String) {
        self.isLoading = true

        call(filename: fileName) { [weak self] (result : Result<CitiesResponse, ARFetchError>) in
            switch result {

            case .success(let response): self?.cityArr = response.cities
                
            case .failure(let errorMessage): self?.alertMessage = "\(errorMessage)"
                
            }
        }
    }
    
    func callFilterValues(filename fileName: String) {
        self.isLoading = true

        call(filename: fileName) { [weak self] (result : Result<FilterModel, ARFetchError>) in
            self?.isLoading = false

            switch result {

            case .success(let response): self?.filterArr = response.flter ?? []
                
            case .failure(let errorMessage): self?.alertMessage = "\(errorMessage)"
                
            }
        }
    }
    
    
    
    func call<T: Decodable>(filename fileName: String, completion: @escaping (Result<T, ARFetchError>) -> ()) {
        self.isLoading = true
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                completion(.success(jsonData))
            }
            catch {
                print("error:\(error)")
            }
        }
        }

    }









