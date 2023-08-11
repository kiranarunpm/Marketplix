//
//  PaginationModel.swift
//  Marketplix
//
//  Created by Kiran P M on 10/08/23.
//

import UIKit

struct ExampleJson2KtSwift: Codable {

  var id            : Int?    = nil
  var name          : String? = nil
  var street        : String? = nil
  var city          : String? = nil
  var state         : String? = nil
  var accessible    : Bool?   = nil
  var unisex        : Bool?   = nil
  var directions    : String? = nil
  var comment       : String? = nil
  var latitude      : Double? = nil
  var longitude     : Double? = nil
  var createdAt     : String? = nil
  var updatedAt     : String? = nil
  var downvote      : Int?    = nil
  var upvote        : Int?    = nil
  var country       : String? = nil
  var changingTable : Bool?   = nil
  var editId        : Int?    = nil
  var approved      : Bool?   = nil

  enum CodingKeys: String, CodingKey {

    case id            = "id"
    case name          = "name"
    case street        = "street"
    case city          = "city"
    case state         = "state"
    case accessible    = "accessible"
    case unisex        = "unisex"
    case directions    = "directions"
    case comment       = "comment"
    case latitude      = "latitude"
    case longitude     = "longitude"
    case createdAt     = "created_at"
    case updatedAt     = "updated_at"
    case downvote      = "downvote"
    case upvote        = "upvote"
    case country       = "country"
    case changingTable = "changing_table"
    case editId        = "edit_id"
    case approved      = "approved"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id            = try values.decodeIfPresent(Int.self    , forKey: .id            )
    name          = try values.decodeIfPresent(String.self , forKey: .name          )
    street        = try values.decodeIfPresent(String.self , forKey: .street        )
    city          = try values.decodeIfPresent(String.self , forKey: .city          )
    state         = try values.decodeIfPresent(String.self , forKey: .state         )
    accessible    = try values.decodeIfPresent(Bool.self   , forKey: .accessible    )
    unisex        = try values.decodeIfPresent(Bool.self   , forKey: .unisex        )
    directions    = try values.decodeIfPresent(String.self , forKey: .directions    )
    comment       = try values.decodeIfPresent(String.self , forKey: .comment       )
    latitude      = try values.decodeIfPresent(Double.self , forKey: .latitude      )
    longitude     = try values.decodeIfPresent(Double.self , forKey: .longitude     )
    createdAt     = try values.decodeIfPresent(String.self , forKey: .createdAt     )
    updatedAt     = try values.decodeIfPresent(String.self , forKey: .updatedAt     )
    downvote      = try values.decodeIfPresent(Int.self    , forKey: .downvote      )
    upvote        = try values.decodeIfPresent(Int.self    , forKey: .upvote        )
    country       = try values.decodeIfPresent(String.self , forKey: .country       )
    changingTable = try values.decodeIfPresent(Bool.self   , forKey: .changingTable )
    editId        = try values.decodeIfPresent(Int.self    , forKey: .editId        )
    approved      = try values.decodeIfPresent(Bool.self   , forKey: .approved      )
 
  }

  init() {

  }

}

