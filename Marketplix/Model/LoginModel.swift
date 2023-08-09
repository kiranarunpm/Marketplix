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
}

struct UserModel: Codable{
    let first_name: String?
    let email: String?
    let phone: String?
}


struct GetOTPModel: Codable{
    let message: String?
}


struct LoginRequest: Codable{
    let email: String
    let otp: String
}

struct GetOtpRequest: Codable{
    let email: String
}
