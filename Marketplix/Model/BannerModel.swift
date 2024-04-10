//
//  BannerModel.swift
//  Marketplix
//
//  Created by Kiran P M on 21/08/23.
//

import Foundation

struct DashboardResponse: Codable{
    let banner1: [Banner]?
    let new_listing: [NewListing]?
    let featured_listing : [DataList]?
    let recommandation: [DataList]?
    let recently_viewed: [DataList]?
    let main_categories: [Category]?

}

struct Banner: Codable{
    let id : Int?
    let name: String?
    let order: Int?
    let description: String?
    let image: String?
    let image_url: String?
}

struct MainCateoroy: Codable {
    let main_categories: [Category]?
}

struct NewListing: Codable{
    let id :Int
    let title:String?
    let description:String?
    let type:Int?
    let addresses: Address?
    let classified_images: [ClassifiedImages]?
    let created_at: String?
    let price : String?
}
struct Address: Codable{
    let building_name: String?
    let street_name: String?
    let pincode: String?
    let sector: String?
    let sub_sector: String?
}

struct ClassifiedImages:Codable{
    let image: String?
    let image_url: String?

}
