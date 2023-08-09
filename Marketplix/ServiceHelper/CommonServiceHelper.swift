//
//  CommonServiceHelper.swift
//  Agri Reach
//
//  Created by Rafiudeen on 19/05/22.
//

import UIKit

enum StatusCode: Int {
    case success = 200
    case unAuthorized = 401
    case internalServerError = 500
    case badRequest = 400
    case payLoadError = 413
    case created = 201

}

enum ARFetchError: Error {
    case invalidURL
    case missingData
    case message(String)
    case inValidResponseFormat
    case offline(String)
    case unKnown
    case LoggedOut
    case BusinessDeactivated
    case OwnerDeactivated
    case BusinessDeleted
    case OwnerDeactivatedMember
    case accessTokenExpire
    case gotNewToken
    case UserDeletedByAdmin
}

struct RefreshTokenRequest: Codable{
    let refreshToken: String?
}

//MARK: TEMP SAVE URLREQUEST
var tokenExpiredReq: URLRequest?


class CommonServiceHelper: NSObject {
    
    static let instance = CommonServiceHelper()
    
    public func request(forUrlRequest urlRequest: URLRequest, completion: @escaping (Result<Data, ARFetchError>) -> ()) {

        var tempReq: URLRequest?
        if urlRequest.url?.path == "/api/auth/refresh_token"{
            tempReq = urlRequest
        }
        else if urlRequest.url?.path == "/api/v1/auth/refresh_token"{
                tempReq = urlRequest
        }
        else{
            tokenExpiredReq = urlRequest
            tempReq = urlRequest
        }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: tempReq!) { data, response, error in
            print("response", response as Any)
            self.processResponse(urlRequest: tempReq!, data: data, response: response, error: error, completion: completion)
        }
        dataTask.resume()
        
    }
    
    private func processResponse(urlRequest: URLRequest, data: Data?, response: URLResponse?, error: Error?, completion : @escaping (Result<Data, ARFetchError>) -> ()) {
        
        guard error == nil else {
            
            if let errorDesc = error?.localizedDescription {
                completion(.failure(.message("HTTP Request Failed \(errorDesc)")))
            }
            return
        }
        
        guard response != nil else {
            completion(.failure(.inValidResponseFormat))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
            completion(.failure(.inValidResponseFormat))
            return
        }
        
        switch statusCode {
            
        case .success:
            
            guard let _data = data else {
                completion(.failure(.missingData))
                return
            }
            completion(.success(_data))
            
        case .created:
            
            guard let _data = data else {
                completion(.failure(.missingData))
                return
            }
            completion(.success(_data))
         //MARK: 401 ERROR - TOKEN EXPIRED.
        case .unAuthorized:
            guard let _data = data else {
                completion(.failure(.inValidResponseFormat))
                return
            }
            do {
                if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                    print("UnAuthorized Response - Token Expired Check ==>", dict)
                
                    if let logDict = dict["logout"] as? Int {
                        if logDict == 1{
                            print("logout hit")
                            let logOutMsg = dict["message"] as? String
                            print("logout hit msg \(String(describing: logOutMsg))")
                            switch logOutMsg{
                            case "LoggedOut":
                                completion(.failure(.LoggedOut))
                                break
                            case "BusinessDeactivated":
                                completion(.failure(.BusinessDeactivated))
                                break
                            case "OwnerDeactivated":
                                completion(.failure(.OwnerDeactivated))
                                break
                            case "BusinessDeleted":
                                completion(.failure(.BusinessDeleted))
                                break
                            case "OwnerDeactivatedMember":
                                completion(.failure(.OwnerDeactivatedMember))
                                break
                            case "UserDeletedByAdmin":
                                completion(.failure(.UserDeletedByAdmin))
                                break
                            default:
                                completion(.failure(.LoggedOut))
                                break
                            }
                            return
                        }
                    }
                    
                    if let messageDict = dict["tokenExpire"] as? Int {
                        if messageDict == 1{
                            print("ACCESS TOKEN EXPIRE hit")
                            completion(.failure(.accessTokenExpire))
                            return
                            /*
                            let request = RefreshTokenRequest(refreshToken: User.shared.refreshToken)
                            //MARK: REQUEST NEW ACCESS TOKEN
                            requestNewAccessToken(router: ARServiceManager.refreshToken(request: request)) { success, msg in
                                if success {
                                    //MARK: CALL LOCAL SAVED URLREQUEST.
                                    self.request(forUrlRequest: tokenExpiredReq!) { (result : Result<Data, ARFetchError>) in
                                        guard let _data = data else {
                                            completion(.failure(.missingData))
                                            return
                                        }
                                        completion(.success(_data))
                                    }
                                }else{
                                    print("REFRESH TOKEN API FAIL")
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: refreshTokenFail), object: nil)
                                    completion(.failure(.message("TOKEN EXPIRED - REFRESH TOKEN API FAIL")))
                                }
                            }
                          */
                        }else{
                            completion(.failure(.message("Token not expired - But UnAuthorized".uppercased())))
                            return
                        }
                                    
                    }else{
                        completion(.failure(.message("Token not expired - But UnAuthorized".uppercased())))
                        return
                    }
                    
                }
                
            }catch (let error) {
                completion(.failure(.message(error.localizedDescription)))
            }
        case .internalServerError:
            completion(.failure(.message("InternalServerError")))
        case .badRequest:
            
            guard let _data = data else {
                completion(.failure(.missingData))
                return
            }
            
            do {
                
                if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                    print("Response ==>", dict)
                    
                    if let messageDict = dict["message"] as? [String : Any],  let errorMessage = messageDict["Details"] as? String {
                        completion(.failure(.message(errorMessage)))
                        return
                    }
                    
                    if let errorMessage = dict["message"] as? String {
                        completion(.failure(.message(errorMessage)))
                        return
                    }
                    
                    if let messageDict = dict["message"] as? [String : Any],  let errorMessage = messageDict["message"] as? String {
                        completion(.failure(.message(errorMessage)))
                        return
                    }
                    
                    if let messageDict = dict["message"] as? [String] {
                        completion(.failure(.message(messageDict.joined(separator: ", "))))
                        return
                    }
                    
                    if let messageDict = dict["message"] as? [AnyObject],  let errorMessage = messageDict[0]["Details"] as? String {
                        completion(.failure(.message(errorMessage.description)))
                        return
                    }
                    
                    completion(.failure(.message("Property required should not exist")))
                    return
                    
                }
                
            }catch (let error) {
                completion(.failure(.message(error.localizedDescription)))
            }
            
        case .payLoadError:
            
            completion(.failure(.message("Request entity too large")))
            return
        }
    }
    
    
    //MARK: REQUEST NEW ACCESS TOKEN FUNCTION
    func requestNewAccessToken(router: ARServiceManager, completion: @escaping (_ success: Bool, _ msg: ARFetchError) -> ()) {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = "/api/v1" + router.path

        guard let url = components.url else {
            completion(false, ARFetchError.invalidURL)
            return
        }
        print("NEW ACCESS TOKEN URL ===> ", url)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method

          HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie) // for use deleteCookie

        for (key, value) in router.headerFields {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        if let data = router.body {
            urlRequest.httpBody = data
        }
        
        self.request(forUrlRequest: urlRequest) { (result : Result<Data, ARFetchError>) in
            DispatchQueue.main.async {
                
                print("REFRESH TOKEN RESULT - \(result)")
                switch result {
                case .success(let data):
                    do {
                        
                        if let dict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any] {
                            
                            print("NEW ACCESS TOKEN RESPONSE ====> ", dict)
                            
                            if let messageDict = dict["data"] as? [String : Any], let accessToken = messageDict["accessToken"] as? String{
                            }
                            if let messageDict = dict["data"] as? [String : Any], let refreshToken = messageDict["refreshToken"] as? String{
                            }
                            
                            if let messageDict = dict["data"] as? [String : Any], let refreshTokenExpTime = messageDict["refreshTokenExpireTime"] as? Int{
                            }
                            completion(true,.message("success"))
                            
                        }else {
                            completion(false,.inValidResponseFormat)
                        }
                        
                    }catch (_) {
                        print("REFRESH TOKEN RESULT error3 - \(result)")
                        completion(false,.inValidResponseFormat)
                    }
             
                case .failure(_):
                    print("REFRESH TOKEN RESULT error1 - \(result)")
                    completion(false,.inValidResponseFormat)
                    
                }
            }
        }
    }
}
