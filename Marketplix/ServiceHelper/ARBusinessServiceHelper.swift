//
//  ARBusinessServiceHelper.swift
//  Agri Reach
//
//  Created by Rafiudeen on 06/06/22.
//

import Foundation

class ARBusinessServiceHelper {
    
    class func request<T: Codable>(router: ARServiceManager, completion: @escaping (Result<T, ARFetchError>) -> ()) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
         components.queryItems = router.parameters
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        print("URL===> ", url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie) // for use deleteCookie
        
        for (key, value) in router.headerFields {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let data = router.body {
            urlRequest.httpBody = data
        }
        
        CommonServiceHelper.instance.request(forUrlRequest: urlRequest, completion: { (result : Result<Data, ARFetchError>) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        
                        if let dict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any] {
                            
                            print("Response====> ", dict)
                            
                            if let responseObject = try? JSONDecoder().decode(T.self, from: data){
                                completion(.success(responseObject))
                                
                            }else {
                                do {
                                    let response = try JSONDecoder().decode(T.self, from: data)
                                    print(response)
                                } catch {
                                    print(error) //here.....
                                }
                                completion(.failure(.inValidResponseFormat))
                            }
                            
                        }else {
                            
                            if let responseObject = try? JSONDecoder().decode(T.self, from: data){
                                print("responseObject :", responseObject)
                                completion(.success(responseObject))
                                
                            }else {
                                completion(.failure(.inValidResponseFormat))
                            }
                        }
                        
                    }catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                case .failure(let message):
                    print("hit failure - \(message)")
                    
                    completion(.failure(message))
                    
                }
            }
        })
    }
    
    class func imageUploadRequest<T: Codable>(router: ARServiceManager, paramName: String, fileName: String, imageData: Data, completion: @escaping (Result<T, ARFetchError>) -> ()) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = "/api/v1" + router.path
        // components.queryItems = router.parameters
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        print("URL===> ", url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie) // for use deleteCookie
        
        for (key, value) in router.headerFields {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlRequest.httpBody = data
        
        CommonServiceHelper.instance.request(forUrlRequest: urlRequest, completion: { (result : Result<Data, ARFetchError>) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        
                        if let dict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any] {
                            
                            print("Response====> ", dict)
                            
                            if let responseObject = try? JSONDecoder().decode(T.self, from: data){
                                completion(.success(responseObject))
                                
                            }else {
                                completion(.failure(.inValidResponseFormat))
                            }
                            
                        }else {
                            
                            if let responseObject = try? JSONDecoder().decode(T.self, from: data){
                                completion(.success(responseObject))
                                
                            }else {
                                completion(.failure(.inValidResponseFormat))
                            }
                        }
                        
                    }catch (let error) {
                        completion(.failure(.message(error.localizedDescription)))
                    }
                    
                case .failure(let message):
                    print("hit failure - \(message)")
                    
                    completion(.failure(message))
                    
                }
            }
        })
    }
}
