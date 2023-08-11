//
//  FilterModel.swift
//  Marketplix
//
//  Created by Kiran P M on 11/08/23.
//

import Foundation

struct FilterModel: Codable {

  var flter : [Flter]? = []
}

struct Flter: Codable {

  var key   : String?  = nil
  var value : [Value]? = []

}

struct Value: Codable {

  var id   : Int?    = nil
  var name : String? = nil


}
