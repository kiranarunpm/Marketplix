//
//  ARServiceManager.swift
//  Agri Reach
//
//  Created by Rafiudeen on 19/05/22.
//

import Foundation


struct API {
    static var scheme = "https"
    
    static var baseURL = "marketplix.in" //dev

    static var mapURl = "maps.googleapis.com"
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
    case login(request: [String: String])
    case getOtp(request: [String:String])
    case flashBanner
    case mainCategory(mainCategory: String)
    case dashboard(lat: String, lng: String)
    case listAdds(_ request: ListRequest)
    case category(_ main_category: String)
    case specGroup(_ request: String)
    case myAds
    case viewAd(_ id: String)
    case addFavAd(_ id: String)
    case listFavAd
    case listRecentlyViewedAd(lat: String, lng: String)
    case listSubscription
    case register(_ request: RegisterRequest)
    case chatList
    case chatinitiate(_ request: [String: String])
    case chatDetails(_ id: String)
    case chatSend(_ request: [String: String])
    case logout
    case queryautocomplete(input: String,key: String)
    case placeDetail(placeID: String,key: String)
    case reportAds(_ request: [String: String])
    case update_token(_ request: String)
    case versionUpdate(_ request: String)
    case updatePostStatus(_ id: String, status: String)
    case deleteAccount
    case notification
    case listGroupedAd(_ type: String, _ request: [String: String])
    case adSuggestions(_ keyword: String)
    case chatCount
    case webPage(_ type: String)
    case chatBlock(_ id: String)


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
        case .logout: return API.scheme
        case .queryautocomplete: return API.scheme
        case .placeDetail: return API.scheme
        case .reportAds: return API.scheme
        case .update_token: return API.scheme
        case .versionUpdate: return API.scheme
        case .updatePostStatus: return API.scheme
        case .deleteAccount: return API.scheme
        case .notification: return API.scheme
        case .listGroupedAd: return API.scheme
        case .adSuggestions: return API.scheme
        case .chatCount: return API.scheme
        case .webPage: return API.scheme
        case .chatBlock: return API.scheme

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
        case .logout: return API.baseURL
        case .queryautocomplete: return API.mapURl
        case .placeDetail: return API.mapURl
        case .reportAds: return API.baseURL
        case .update_token: return API.baseURL
        case .versionUpdate: return API.baseURL
        case .updatePostStatus: return API.baseURL
        case .deleteAccount: return API.baseURL
        case .notification: return API.baseURL
        case .listGroupedAd: return API.baseURL
        case .adSuggestions: return API.baseURL
        case .chatCount: return API.baseURL
        case .webPage: return API.baseURL
        case .chatBlock: return API.baseURL

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
        case .listRecentlyViewedAd: return "/api/list-recently-viewed-ad"
        case .listSubscription: return "/api/list-subscription"
        case .register: return "/api/register"
        case .chatList: return "/api/chat-list"
        case .chatinitiate: return "/api/chat-initiate"
        case .chatDetails(let id): return "/api/chat-details/\(id)"
        case .chatSend: return "/api/chat-send"
        case .logout: return "/api/logout"
        case .queryautocomplete: return "/maps/api/place/autocomplete/json"
        case .placeDetail: return "/maps/api/place/details/json"
        case .reportAds: return "/api/report-ad"
        case .update_token: return "/api/update-token"
        case .versionUpdate(let type): return "/api/app-version/\(type)"
        case .updatePostStatus(let id, let status): return "/api/update-ad/\(id)/change-status/\(status)"
        case .deleteAccount: return "/api/delete-user"
        case .notification: return "/api/notification"
        case .listGroupedAd(let type, _): return "/api/list-grouped-ad/\(type)"
        case .adSuggestions(let keyword): return "/api/ad-suggestions/\(keyword)"
        case .chatCount: return "/api/chat-count"
        case .webPage(let type): return "/api/page/\(type)"
        case .chatBlock(let id): return "/api/chat-block/\(id)"

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
        case .logout: return HttpMethod.get.rawValue
        case .queryautocomplete: return HttpMethod.get.rawValue
        case .placeDetail: return HttpMethod.get.rawValue
        case .reportAds: return HttpMethod.post.rawValue
        case .update_token: return HttpMethod.get.rawValue
        case .versionUpdate: return HttpMethod.get.rawValue
        case .updatePostStatus: return HttpMethod.get.rawValue
        case .deleteAccount: return HttpMethod.get.rawValue
        case .notification: return HttpMethod.get.rawValue
        case .listGroupedAd: return HttpMethod.get.rawValue
        case .adSuggestions: return HttpMethod.get.rawValue
        case .chatCount: return HttpMethod.get.rawValue
        case .webPage: return HttpMethod.get.rawValue
        case .chatBlock: return HttpMethod.get.rawValue


        }
    }

    var parameters: [URLQueryItem]? {
        let encodedURLString = "country:in"

        switch self {
        case .basecase: return nil
        case .login: return nil
        case .getOtp: return nil
        case .flashBanner: return nil
        case .mainCategory(let mainCategory): return [URLQueryItem(name: "main_category", value: mainCategory)]
        case .dashboard(let lat, let lng):  return [URLQueryItem(name: "lat", value: lat), URLQueryItem(name: "lng", value: lng)]
        case .listAdds(let list): return [URLQueryItem(name: "page", value: list.page), URLQueryItem(name: "search", value: list.search ?? ""), URLQueryItem(name: "category_id", value: list.category_id  ), URLQueryItem(name: "lat", value: list.lat  ), URLQueryItem(name: "lng", value: list.lng), URLQueryItem(name: "group_type", value: list.groupType), URLQueryItem(name: "sortby", value: ""), URLQueryItem(name: "sortby", value: list.sortby.rawValue), URLQueryItem(name: "price_min", value: list.price_min), URLQueryItem(name: "price_max", value: list.price_max)]
        case .category(let main_category) : return  [URLQueryItem(name: "main_category", value: main_category)]
        case .specGroup(let category) : return  [URLQueryItem(name: "category", value: category)]
        case .myAds: return nil
        case .viewAd: return nil
        case .addFavAd: return nil
        case .listFavAd: return nil
        case .listRecentlyViewedAd(let lat, let lng): return [URLQueryItem(name: "lat", value: lat), URLQueryItem(name: "lng",value: lng)]
        case .listSubscription: return nil
        case .register: return nil
        case .chatList: return nil
        case .chatinitiate: return nil
        case .chatDetails: return nil
        case .chatSend: return nil
        case .logout: return nil
        case .queryautocomplete(let input, let key): return  [URLQueryItem(name: "input", value: input), URLQueryItem(name: "key", value: key), URLQueryItem(name: "components", value: encodedURLString),]
        case .placeDetail(let placeID, let key): return  [URLQueryItem(name: "place_id", value: placeID), URLQueryItem(name: "key", value: key)]
        case .reportAds: return nil
        case .update_token(let device_token): return  [URLQueryItem(name: "device_token", value: device_token)]
        case .versionUpdate: return nil
        case .updatePostStatus: return nil
        case .deleteAccount: return nil
        case .notification: return nil
        case .listGroupedAd(_ , let listGroupedAd): return [URLQueryItem(name: "page", value: listGroupedAd["page"]), URLQueryItem(name: "lat", value: listGroupedAd["lat"]), URLQueryItem(name: "lng", value: listGroupedAd["lng"]),]
        case .adSuggestions: return nil
        case .chatCount: return nil
        case .webPage: return nil
        case .chatBlock: return nil

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
        case .logout: return nil
        case .queryautocomplete: return nil
        case .placeDetail: return nil
        case .reportAds(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .update_token: return nil
        case .versionUpdate: return nil
        case .updatePostStatus: return nil
        case .deleteAccount: return nil
        case .notification: return nil
        case .listGroupedAd: return nil
        case .adSuggestions: return nil
        case .chatCount: return nil
        case .webPage: return nil
        case .chatBlock: return nil

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
        case .logout : return nil
        case .queryautocomplete : return nil
        case .placeDetail : return nil
        case .reportAds : return nil
        case .update_token : return nil
        case .versionUpdate : return nil
        case .updatePostStatus : return nil
        case .deleteAccount : return nil
        case .notification : return nil
        case .listGroupedAd : return nil
        case .adSuggestions : return nil
        case .chatCount : return nil
        case .webPage : return nil
        case .chatBlock : return nil

        }
    }
    
    var headerFields: [String : String] {
        let commonHeader : [String:String] = ["content-type" : ContentType.json.rawValue,"Authorization": "Bearer \(User.shared.token)", "Accept":"application/json"]
        switch self {
            
        case .basecase: return ["content-Type" : ContentType.json.rawValue, "Accept":"application/json"]
        case .login: return ["content-type": ContentType.json.rawValue, "Accept":"application/json"]
        case .getOtp: return ["content-type": ContentType.json.rawValue, "Accept":"application/json"]
        case .flashBanner: return commonHeader
        case .mainCategory: return commonHeader
        case .dashboard: return User.shared.token != "" ? commonHeader : ["content-type": ContentType.json.rawValue, "Accept":"application/json"]
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
        case .logout: return commonHeader
        case .queryautocomplete: return ["content-type": ContentType.json.rawValue, "Accept":"application/json"]
        case .placeDetail: return ["content-type": ContentType.json.rawValue, "Accept":"application/json"]
        case .reportAds: return commonHeader
        case .update_token: return commonHeader
        case .versionUpdate: return commonHeader
        case .updatePostStatus: return commonHeader
        case .deleteAccount: return commonHeader
        case .notification: return commonHeader
        case .listGroupedAd: return commonHeader
        case .adSuggestions: return commonHeader
        case .chatCount: return commonHeader
        case .webPage: return commonHeader
        case .chatBlock: return commonHeader

        }
    }
}
