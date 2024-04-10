//
//  PostRealEstateModel.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit

struct PostRealEstateModel: Codable{
    var key : String?
    var name : String?
    var value : String?
    var type : String?
    var required: Bool?
    var id : String?
    var keyboard : String?
    var results: [PostRealEstateModel]?
}

