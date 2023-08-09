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
    
    
}
