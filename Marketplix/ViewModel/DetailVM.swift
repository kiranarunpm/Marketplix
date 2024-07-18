//
//  DetailVM.swift
//  Marketplix
//
//  Created by Kiran on 07/10/23.
//

import Foundation

class DetailVM{
    public var successClosure: (() -> ())?
    public var failureClosure:(() -> ())?
    public var loadingStatus:(() -> ())?
    
    public var detailResponsel : DetailResponse? {
        didSet{
            self.successClosure?()
        }
    }
    
    public var successResponse : SuccessResponse? {
        didSet{
            self.successClosure?()
        }
    }
    
    
    public var dataListArr: [DataList] = [] {
        didSet{
            self.successClosure?()
        }
    }
    
    public var subscriptionResponse: SubscriptionResponse? {
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

extension DetailVM{
    
    func callDetail(_ id: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.viewAd(id)) { [weak self] (result : Result<DetailResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.detailResponsel = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callAddFav(_ id: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.addFavAd(id)) { [weak self] (result : Result<SuccessResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.successResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callListingFav() {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.listFavAd) { [weak self] (result : Result<FavListItemResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.dataListArr = response.classifields?.data ?? []
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callListingRecentlyViewed(lat: String, lng: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.listRecentlyViewedAd(lat: lat, lng: lng)) { [weak self] (result : Result<ListItemResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.dataListArr = response.classifields?.data ?? []
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callSubsriptionList() {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.listSubscription) { [weak self] (result : Result<SubscriptionResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.subscriptionResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callReportAds(_ reguest: [String: String]) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.reportAds(reguest)) { [weak self] (result : Result<SubscriptionResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.subscriptionResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
}
