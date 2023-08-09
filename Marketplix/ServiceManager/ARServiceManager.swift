//
//  ARServiceManager.swift
//  Agri Reach
//
//  Created by Rafiudeen on 19/05/22.
//

import Foundation

//https://agrireach-backend.azurewebsites.net/bussiness
//https://agrireach-backend.azurewebsites.net/
//https://slcmqa.nuvento.com/api
//https://slcmdev.nuvento.com/api

struct API {
    static var scheme = "http"
    
    static var baseURL = "marketplix.com" //dev

    static var path = ""
    static var port = 0
}

enum HttpMethod: String {
    case get
    case post
    case put
    case PATCH
    case delete
}

enum ContentType : String {
    case formData = "multipart/form-data"
    case json = "application/json"
    case x_www_form_urlEncoded = "application/x-www-form-urlencoded"
    case Authorization = "Bearer "
    
}

enum ARServiceManager {
    
    case basecase
    case login(request: LoginRequest)
    case getOtp(request: GetOtpRequest)
    case flashBanner

    var scheme: String {
        switch self {
        case .basecase: return API.scheme
        case .login: return API.scheme
        case .getOtp: return API.scheme
        case .flashBanner: return API.scheme

        }
    }
    
    var host: String {
        switch self {
            
        case .basecase: return ""
        case .login, .getOtp, .flashBanner: return API.baseURL



        }
    }
    
    var path: String {
        switch self {
            
        case .basecase: return "/api/login"
        case .login: return "/api/login"
        case .getOtp: return "/api/get-otp"
        case .flashBanner: return "/api/flash-banners"

        }
    }
    
    var method: String {
        switch self {
        case .basecase: return HttpMethod.post.rawValue
        case .login: return HttpMethod.post.rawValue
        case .getOtp: return HttpMethod.post.rawValue
        case .flashBanner: return HttpMethod.get.rawValue

        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .basecase: return nil
        case .login: return nil
        case .getOtp: return nil
        case .flashBanner: return nil

        }
        
    }
    
    var body: Data? {
        switch self {
            
        case .basecase: return nil
        case .login(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
            
        case .getOtp(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .flashBanner: return nil

        }
    }
    
    
    var formDataParameters : [URLQueryItem]? {
        switch self {
        case .basecase : return nil
        case .login : return nil
        case .getOtp : return nil
        case .flashBanner : return nil

        }
    }
    
    var headerFields: [String : String] {
        let commonHeader : [String:String] = ["Content-Type" : ContentType.json.rawValue,"Authorization": "Bearer \(User.shared.token)"]
        switch self {
            
        case .basecase: return ["Content-Type" : ContentType.json.rawValue, "Accept":"*/*"]
        case .login: return ["Content-Type": ContentType.json.rawValue, "Accept":"*/*"]
        case .getOtp: return ["Content-Type": ContentType.json.rawValue, "Accept":"*/*"]
        case .flashBanner: return commonHeader

        }
    }
}
