//
//  ARServiceManager.swift
//  Agri Reach
//
//  Created by Rafiudeen on 19/05/22.
//

import Foundation


struct API {
    static var scheme = "https"
    
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
    case mainCategory(mainCategory: String)
    case dashboard
    case listAdds(_ request: ListRequest)
    case category(_ main_category: String)
    case specGroup(_ request: String)
    case myAds
    case viewAd(_ id: String)
    case addFavAd(_ id: String)
    case listFavAd
    case listRecentlyViewedAd
    case listSubscription
    case register(_ request: RegisterRequest)
    case chatList
    case chatinitiate(_ request: [String: String])
    case chatDetails(_ id: String)
    case chatSend(_ request: [String: String])

    

    var scheme: String {
        switch self {
        case .basecase: return API.scheme
        case .login: return API.scheme
        case .getOtp: return API.scheme
        case .flashBanner: return API.scheme
        case .mainCategory: return API.scheme
        case .dashboard: return API.scheme
        case .listAdds: return API.scheme
        case .category: return API.scheme
        case .specGroup: return API.scheme
        case .myAds: return API.scheme
        case .viewAd: return API.scheme
        case .addFavAd: return API.scheme
        case .listFavAd: return API.scheme
        case .listRecentlyViewedAd: return API.scheme
        case .listSubscription: return API.scheme
        case .register: return API.scheme
        case .chatList: return API.scheme
        case .chatinitiate: return API.scheme
        case .chatDetails: return API.scheme
        case .chatSend: return API.scheme

        }
    }
    
    var host: String {
        switch self {
            
        case .basecase: return ""
        case .login, .getOtp, .flashBanner, .mainCategory, .dashboard, .listAdds, .category, .specGroup, .myAds, .viewAd : return API.baseURL

        case .addFavAd: return API.baseURL
        case .listFavAd: return API.baseURL
        case .listRecentlyViewedAd: return API.baseURL
        case .listSubscription: return API.baseURL
        case .register: return API.baseURL

        case .chatList: return API.baseURL
        case .chatinitiate: return API.baseURL
        case .chatDetails: return API.baseURL
        case .chatSend: return API.baseURL


        }
    }
    
    var path: String {
        switch self {
            
        case .basecase: return "/api/login"
        case .login: return "/api/login"
        case .getOtp: return "/api/get-otp"
        case .flashBanner: return "/api/flash-banners"
        case .mainCategory: return "/api/category"
        case .dashboard: return "/api/dashboard"
        case .listAdds: return "/api/list-ad"
        case .category: return "/api/category"
        case .specGroup: return "/api/spec-group"
        case .myAds: return "/api/list-my-ad"
        case .viewAd(let id): return "/api/view-ad/\(id)"
        case .addFavAd(let id): return "/api/add-fav-ad/\(id)"
        case .listFavAd: return "/api/list-fav-ad"
        case .listRecentlyViewedAd: return "/api/list-fav-ad"
        case .listSubscription: return "/api/list-subscription"
        case .register: return "/api/register"
        case .chatList: return "/api/chat-list"
        case .chatinitiate: return "/api/chat-initiate"
        case .chatDetails(let id): return "/api/chat-details/\(id)"
        case .chatSend: return "/api/chat-send"

        }
    }
    
    var method: String {
        switch self {
        case .basecase: return HttpMethod.post.rawValue
        case .login: return HttpMethod.post.rawValue
        case .getOtp: return HttpMethod.post.rawValue
        case .flashBanner: return HttpMethod.get.rawValue
        case .mainCategory: return HttpMethod.get.rawValue
        case .dashboard: return HttpMethod.get.rawValue
        case .listAdds: return HttpMethod.get.rawValue
        case .category: return HttpMethod.get.rawValue
        case .specGroup: return HttpMethod.get.rawValue
        case .myAds: return HttpMethod.get.rawValue
        case .viewAd: return HttpMethod.get.rawValue
        case .addFavAd: return HttpMethod.get.rawValue
        case .listFavAd: return HttpMethod.get.rawValue
        case .listRecentlyViewedAd: return HttpMethod.get.rawValue
        case .listSubscription: return HttpMethod.get.rawValue
        case .register: return HttpMethod.post.rawValue
        case .chatList: return HttpMethod.get.rawValue
        case .chatinitiate: return HttpMethod.post.rawValue
        case .chatDetails: return HttpMethod.get.rawValue
        case .chatSend: return HttpMethod.post.rawValue

        }
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case .basecase: return nil
        case .login: return nil
        case .getOtp: return nil
        case .flashBanner: return nil
        case .mainCategory(let mainCategory): return [URLQueryItem(name: "main_category", value: mainCategory)]
        case .dashboard: return nil
        case .listAdds: return nil
        case .category(let main_category) : return  [URLQueryItem(name: "main_category", value: main_category)]
        case .specGroup(let category) : return  [URLQueryItem(name: "category", value: category)]
        case .myAds: return nil
        case .viewAd: return nil
        case .addFavAd: return nil
        case .listFavAd: return nil
        case .listRecentlyViewedAd: return nil
        case .listSubscription: return nil
        case .register: return nil
        case .chatList: return nil
        case .chatinitiate: return nil
        case .chatDetails: return nil
        case .chatSend: return nil

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
        case .mainCategory: return nil
        case .dashboard: return nil
        case .listAdds: return nil
        case .category: return nil
        case .specGroup: return nil
        case .myAds: return nil
        case .viewAd: return nil
        case .addFavAd: return nil
        case .listFavAd: return nil
        case .listRecentlyViewedAd: return nil
        case .listSubscription: return nil
        case .register(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .chatList: return nil
            
        case .chatinitiate(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .chatDetails: return nil
        case .chatSend(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)

        }
    }
    
    
    var formDataParameters : [URLQueryItem]? {
        switch self {
        case .basecase : return nil
        case .login : return nil
        case .getOtp : return nil
        case .flashBanner : return nil
        case .mainCategory : return nil
        case .dashboard : return nil
        case .listAdds : return nil
        case .category : return nil
        case .specGroup : return nil
        case .myAds : return nil
        case .viewAd : return nil
        case .addFavAd : return nil
        case .listFavAd : return nil
        case .listRecentlyViewedAd : return nil
        case .listSubscription : return nil
        case .register : return nil
        case .chatList : return nil
        case .chatinitiate : return nil
        case .chatDetails : return nil
        case .chatSend : return nil

        }
    }
    
    var headerFields: [String : String] {
        let commonHeader : [String:String] = ["content-type" : ContentType.json.rawValue,"Authorization": "Bearer \(User.shared.token)"]
        switch self {
            
        case .basecase: return ["content-Type" : ContentType.json.rawValue, "Accept":"*/*"]
        case .login: return ["content-type": ContentType.json.rawValue, "Accept":"*/*"]
        case .getOtp: return ["content-type": ContentType.json.rawValue, "Accept":"*/*"]
        case .flashBanner: return commonHeader
        case .mainCategory: return commonHeader
        case .dashboard: return commonHeader
        case .listAdds: return commonHeader
        case .category: return commonHeader
        case .specGroup: return commonHeader
        case .myAds: return commonHeader
        case .viewAd: return commonHeader
        case .addFavAd: return commonHeader
        case .listFavAd: return commonHeader
        case .listRecentlyViewedAd: return commonHeader
        case .listSubscription: return commonHeader
        case .register: return commonHeader
        case .chatList: return commonHeader
        case .chatinitiate: return commonHeader
        case .chatDetails: return commonHeader
        case .chatSend: return commonHeader

        }
    }
}
