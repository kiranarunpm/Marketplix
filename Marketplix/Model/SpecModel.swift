//
//  SpecModel.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit

struct SpecModel: Codable{
    let spec_groups: [SpecGroup]?
}

struct SpecGroup: Codable {
    let id: Int?
    let name: String?
    let order: Int?
    let spec_group_id: Int?
    let spec_items: [SpecGroup]?
}
