//
//  CategoryModel.swift
//  Marketplix
//
//  Created by Kiran P M on 21/08/23.
//

import Foundation

struct CategoryModels: Codable{
    let categories : [Category]
}

struct Category: Codable{
    
    let id: Int
    let name: String
    let order: Int
    let image_url: String
    let sub_category: [String]
}
