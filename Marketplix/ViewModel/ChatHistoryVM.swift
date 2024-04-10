//
//  ChatHistoryVM.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import Foundation

class ChatHistoryVM{
    
    public var successClosure: (() -> ())?
    public var failureClosure:(() -> ())?
    public var loadingStatus:(() -> ())?
    
    public var chatHistoryResponse: ChatHistoryResponse? {
        didSet{
            self.successClosure?()
        }
    }
    
    public var chatIniateResponse: ChatIniateResponse? {
        didSet{
            self.successClosure?()
        }
    }
    
    
    public var chatDetailsResponse: ChatDetailsResponse? {
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


extension ChatHistoryVM {
    
    func callChatList() {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.chatList) { [weak self] (result : Result<ChatHistoryResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.chatHistoryResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    
    func callChatInitiate(_ request: [String: String]) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.chatinitiate(request)) { [weak self] (result : Result<ChatIniateResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.chatIniateResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callChatDetails(_ request: String) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.chatDetails(request)) { [weak self] (result : Result<ChatDetailsResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.chatDetailsResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
    func callSendBtn(_ request: [String : String]) {
        self.isLoading = true
        
        ARBusinessServiceHelper.request(router: ARServiceManager.chatSend(request)) { [weak self] (result : Result<ChatDetailsResponse, ARFetchError>) in
            
            guard let _self = self else { return }
            
            _self.isLoading = false
            
            switch result {
                
            case .success(let response): _self.chatDetailsResponse = response
                
            case .failure(let errorMessage): _self.alertMessage = "\(errorMessage)"
                
            }
        }
        
    }
    
}
