//
//  PostAdsVM.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import Foundation

class PostAdsVM{
    public var successClosure: (() -> ())?
    public var failureClosure:(() -> ())?
    public var loadingStatus:(() -> ())?
    
    public var postRealEstateArr : [PostRealEstateModel] = [] {
        didSet{
            self.successClosure?()
        }
    }

    public var specModel: SpecModel? {
        didSet{
            self.successClosure?()
        }
    }
    
    public var listItemResponse: ListItemResponse? {
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

extension PostAdsVM {
    
    func callPostValues() {
        self.isLoading = true
        
        ConvertJsonFile.call(filename: "PostRealEstate") { [weak self] (result : Result<[PostRealEstateModel], ARFetchError>) in
            switch result {
                
            case .success(let response): self?.postRealEstateArr = response
                
            case .failure(let errorMessage): self?.alertMessage = "\(errorMessage)"
                
            }
        }
    }
    
    
    func callSpecGroup(_ category: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.specGroup(category)) { [weak self] (result : Result<SpecModel, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.specModel = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    
    func callMyAds() {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.myAds) { [weak self] (result : Result<ListItemResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.listItemResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    
    
    
}
