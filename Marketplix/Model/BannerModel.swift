//
//  BannerModel.swift
//  Marketplix
//
//  Created by Kiran P M on 21/08/23.
//

import Foundation

struct DashboardResponse: Codable{
    let banner1: [Banner]?
    var new_listing: [NewListing]?
    var featured_listing : [DataList]?
    var recommandation: [DataList]?
    var recently_viewed: [DataList]?
    let main_categories: [Category]?
    let chat_count: Int

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
    let addresses: Address?
    let classified_images: [ClassifiedImages]?
    let created_at: String?
    let price : String?
    var is_fav: Int?
    let category: CategoryItem?
    let status: String?
    let time_diff : String?


}
struct Address: Codable{
    let building_name: String?
    let street_name: String?
    let pincode: String?
    let sector: String?
    let sub_sector: String?
    let distance : String?
}

struct ClassifiedImages:Codable{
    let image: String?
    let image_url: String?

}
