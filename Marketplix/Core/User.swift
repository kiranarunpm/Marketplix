//
//  Constant.swift
//  Where2Go
//
//  Created by Kiran on 03/09/23.
//

import Foundation

enum SaveData: String{
    case accessToken
    case refreshToken
    case name
    case email
    case image
    case profile_path
    case walkthough
    case id
    case skip
    case mobile
    
    case location
    case lat
    case long
    
    case fcmToken
    
    case isEnableAllowAccess
}

class User{
    
    static var shared: User = User()
    var tokenKey : String = "accessToken"
    var doneWalkthough : String = "doneWalkthough"

    
    private let defaults = UserDefaults.standard
    
    // ********* Get Data **********
    
    var hasToken: Bool{
        return token == "" ? false : true
    }
    
    var isSkipped: Bool{
        return skiped == "true" ? true : false
    }

    var token: String {
        print("token: ",defaults.string(forKey: SaveData.accessToken.rawValue) ?? "")
        return  defaults.string(forKey: SaveData.accessToken.rawValue) ?? ""
    }
    
    var skiped: String {
        return defaults.string(forKey: SaveData.skip.rawValue) ?? ""
    }
    
    var walkThought: Bool {
        return defaults.bool(forKey: SaveData.walkthough.rawValue)
    }
    
    // ********* Save Data **********
    
    func saveData(with key: SaveData, value: String){
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    func saveWalkthrough(with key: SaveData, value: Bool){
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    func getSavedData(with key: SaveData)->String{
        return defaults.string(forKey: key.rawValue) ?? ""
    }
    
    func deleteUserData(){
        saveData(with: .accessToken, value: "")
        saveData(with: .accessToken, value: "")
        saveData(with: .name, value: "")

    }
}
