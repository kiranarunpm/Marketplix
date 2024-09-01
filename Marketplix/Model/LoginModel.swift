//
//  LoginModel.swift
//  Marketplix
//
//  Created by Kiran PM on 25/07/23.
//

import Foundation

struct LoginModel: Codable{
    let message : String?
    let user: UserModel?
    let token: String?
    let user_id: String?

}



struct UserModel: Codable{
    let first_name: String?
    let email: String?
    let phone: String?
    let user_id: Int?
    
}


struct GetOTPModel: Codable{
    let message: String?
    let exist_user : Int?
}


struct LoginRequest: Codable{
    let email: String
    let otp: String
}

struct GetOtpRequest: Codable{
    let email: String
}


struct RegisterRequest: Codable{
    let first_name: String
    var otp: String
    let email: String
    let phone: String
}




struct PageResponse: Codable{
    let page: ContentResponse?
}

struct ContentResponse : Codable{
    let content: String?
}
