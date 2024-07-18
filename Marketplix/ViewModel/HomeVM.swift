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
    public var classifields : Classifields? {
        didSet{
            self.successClosure?()
        }
    }
    
    
    public var versionResponse : VersionResponse? {
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
    
    func callDashboard(lat: String, lng: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.dashboard(lat: lat, lng: lng)) { [weak self] (result : Result<DashboardResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.dashboardResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callListing(_ request: ListRequest) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.listAdds(request)) { [weak self] (result : Result<ListItemResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.classifields = response.classifields
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callCategory(_ main_category: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.category(main_category)) { [weak self] (result : Result<CategoryModels, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.categoryArr = response.categories
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callUpdatetoken(_ token: String) {
        
        ARBusinessServiceHelper.request(router: ARServiceManager.update_token(token)) { [weak self] (result : Result<CategoryModels, ARFetchError>) in
            
            guard let _self = self else { return }
            
            
          
        }
        
    }
    
    func callVersionUpdate(_ version: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.versionUpdate(version)) { [weak self] (result : Result<VersionResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.versionResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
}

struct VersionResponse: Codable{
    let versions: [Versions]?
}
struct Versions: Codable{
    let id: Int?
    let os: String?
    let version: Double?
    let mandatory: Int
    
}
