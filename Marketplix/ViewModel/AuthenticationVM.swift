//
//  AuthenticationVM.swift
//  Marketplix
//
//  Created by Kiran PM on 25/07/23.
//

import UIKit

protocol AuthenticationDelegate{
     func callGenerateOTP(_ request: GetOtpRequest)
     func callLogin(_ request: LoginRequest) 
}


class AuthenticationVM: AuthenticationDelegate {

    public var successClosure: (() -> ())?
    public var failureClosure:(() -> ())?
    public var loadingStatus:(() -> ())?

    public var loginResponse: LoginModel? {
        didSet{
            self.successClosure?()
        }
    }
    
    public var getOtpResponse: GetOTPModel? {
        didSet{
            self.successClosure?()
        }
    }
    
    public var submitResponse: LoginModel? {
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


extension AuthenticationVM {
    
     func callGenerateOTP(_ request: GetOtpRequest) {
        self.isLoading = true

        
            ARBusinessServiceHelper.request(router: ARServiceManager.getOtp(request: request)) { [weak self] (result : Result<GetOTPModel, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.getOtpResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
    }
    
     func callLogin(_ request: LoginRequest) {
        self.isLoading = true

        
            ARBusinessServiceHelper.request(router: ARServiceManager.login(request: request)) { [weak self] (result : Result<LoginModel, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response):
            _self.loginResponse = response
            User.shared.saveData(with: .accessToken, value: response.token ?? "")
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
    }
}
