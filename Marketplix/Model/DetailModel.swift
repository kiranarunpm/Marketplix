//
//  DetailModel.swift
//  Marketplix
//
//  Created by Kiran on 07/10/23.
//

import Foundation

struct DetailResponse: Codable{
    var classifield : Classifield?

}

struct Classifield : Codable {
    let id : Int?
    let title : String?
    let description : String?
    let price : String?
    let user_id : String?
    let status : String?
    let created_at : String?
    let updated_at : String?
    var spec_groups : [Spec_groups]?
    let is_fav : Int?
    let addresses : Addresses?
    let classified_images : [Classified_images]?
    let share_url: String?
    let category: CategoryItem?
    let user: UserPost?
    let time_diff : String?
    let view_count: Int?


    
    
    
}
struct UserPost: Codable{
    let first_name: String?
    let created_at: String?
    let id : Int?
}

struct SuccessResponse: Codable{
    let message: String?
    let chat: ChatDetailsResponse?
}

