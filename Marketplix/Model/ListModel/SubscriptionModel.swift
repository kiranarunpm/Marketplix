//
//  SubscriptionModel.swift
//  Marketplix
//
//  Created by Kiran on 08/10/23.
//

import Foundation

struct SubscriptionResponse: Codable {
    let subscription_plans : [Subscription_plans]?
    let message: String?
}

struct Subscription_plans : Codable {
    let id : Int?
    let name : String?
    let description : String?
    let price : String?
    let plan_type : Int?
    let ad_limit : Int?
    let available_from : String?
    let available_to : String?
    let validity : Int?
    let status : Bool?
    let created_at : String?
    let updated_at : String?
}
