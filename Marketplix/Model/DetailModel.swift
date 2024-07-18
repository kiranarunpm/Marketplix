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
    let type : Int?
    let price : String?
    let order : Int?
    let user_id : Int?
    let category_id : Int?
    let address_id : Int?
    let ad_type : Int?
    let status : Int?
    let created_at : String?
    let updated_at : String?
    var spec_groups : [Spec_groups]?
    let is_fav : Int?
    let addresses : Addresses?
    let classified_images : [Classified_images]?
    let share_url: String?
    let category: CategoryItem?

    
    
    
}

struct SuccessResponse: Codable{
    let message: String?
}
