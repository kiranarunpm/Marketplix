//
//  User.swift
//  Marketplix
//
//  Created by Kiran PM on 25/07/23.
//

import UIKit

enum SaveData: String{
    case accessToken
    case fullname
    case email
    case mobile
}

class User{
    
    static var shared: User = User()
    var tokenKey : String = "accessToken"
    
    private let defaults = UserDefaults.standard

    // ********* Get Data **********
    
    var hasToken: Bool{
        return token == "" ? false : true
    }

    var token: String {
        print("token: ",defaults.string(forKey: SaveData.accessToken.rawValue) ?? "")
        return defaults.string(forKey: tokenKey) ?? "20|JztTeqtsMmh1qQc5QYbxf32NTwCeLVo4kDlp2prA"
    }
    
    // ********* Save Data **********
    
    func saveData(with key: SaveData, value: String){
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
}
