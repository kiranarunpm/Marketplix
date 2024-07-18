//
//  LocationResponse.swift
//  Marketplix
//
//  Created by Kiran on 13/04/2024.
//

import Foundation

struct LocationResponse: Codable{
    let predictions : [Predictions]?
}

struct Predictions: Codable{
    let place_id : String?
    let structured_formatting : StructuredFormatting?
    
}

struct StructuredFormatting: Codable{
    let main_text: String?
    
}

struct CityDetailResponse: Codable {
    var result: CityDetailResult?
}
struct CityDetailResult: Codable{
    var geometry: Geometry?
    var formatted_address: String?
    var name: String?
}
struct Geometry: Codable{
    let location: LocationResult?
}

struct LocationResult: Codable{
    let lat: Double?
    let lng: Double?
}
