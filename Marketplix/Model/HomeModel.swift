//
//  HomeModel.swift
//  Marketplix
//
//  Created by Kiran on 05/08/23.
//

import Foundation

struct FlashBannerResponse: Codable{
    let flash:[Flash]?
}

struct Flash: Codable{
    let id: Int?
    let name: String?
    let order: Int?
    let description: String?
    let image: String?
    let image_url: String?

}
