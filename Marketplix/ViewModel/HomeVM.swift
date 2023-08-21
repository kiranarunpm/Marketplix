//
//  HomeVM.swift
//  Marketplix
//
//  Created by Kiran on 05/08/23.
//

import Foundation

class HomeVM{
    public var successClosure: (() -> ())?
    public var failureClosure:(() -> ())?
    public var loadingStatus:(() -> ())?
    
    public var flashBannerResponse: FlashBannerResponse? {
        didSet{
            self.successClosure?()
        }
    }
    
    public var categoryArr: [Category] = [Category]() {
        didSet{
            self.successClosure?()
        }
    }
    
    public var dashboardResponse: DashboardResponse? {
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


extension HomeVM {
    
    func callFlashBanner() {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.flashBanner) { [weak self] (result : Result<FlashBannerResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.flashBannerResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    
    func callMainCategory(mainCategory: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.mainCategory(mainCategory: mainCategory)) { [weak self] (result : Result<CategoryModels, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.categoryArr = response.categories
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callDashboard() {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.dashboard) { [weak self] (result : Result<DashboardResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.dashboardResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
}
