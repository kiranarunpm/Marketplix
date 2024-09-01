//
//  CityModel.swift
//  Marketplix
//
//  Created by Kiran P M on 11/08/23.
//

import Foundation


struct CitiesResponse: Decodable {
    var cities: [City]
}
struct City : Decodable {
    var id: Int
    var title: String
    var cord: Coordinate
}
struct Coordinate: Decodable{
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
}


struct NotificationsReponse: Codable {
    let notifications: [Notifications]?
}

struct Notifications: Codable {
    let title: String?
    let content: String?
    let created_at : String?
}
