//
//  CategoryModel.swift
//  Marketplix
//
//  Created by Kiran PM on 18/07/24.
//

import Foundation

struct CategoryModels: Codable{
    let categories : [Category]
}

struct Category: Codable{
    
    let id: Int?
    let name: String?
    let order: Int?
    let image_url: String?
    let sub_category: [Category]?
}
