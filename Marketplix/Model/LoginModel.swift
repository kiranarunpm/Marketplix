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
    
    enum CodingKeys: String, CodingKey {

        case first_name = "first_name"
        case email = "email"
        case phone = "phone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        if let phone = try values.decodeIfPresent(Double.self, forKey: .phone){
            self.phone = String(phone)
        }else{
            phone = try values.decodeIfPresent(String.self, forKey: .phone)

    }

}
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
    let dob: String
}
