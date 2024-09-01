/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct DataList : Codable {
	let id : Int?
	let title : String?
	let description : String?
    let price: String?
	let user_id : String?
	let category_id : String?
	let status : String?
	let created_at : String?
	let updated_at : String?
	let spec_groups : [SpecGroup]?
	let addresses : Addresses?
	let classified_images : [Classified_images]?
    let classifieds: NewListing?
    var is_fav: Int?
    let time_diff : String?
    let category: CategoryItem?
    
}
struct CategoryItem: Codable{
    let id : Int?
    let name : String?
}
struct Spec_groups : Codable {
    let id : Int?
    var name : String?
    let category_id : Int?
    let status : String?
    var spec_items : [Spec_items]?
    
    
    
    init(name: String, spec_items: [Spec_items]){
        self.name = name
        self.spec_items = spec_items
        self.category_id = 0
        self.id = 0
        self.status = ""
    }

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case category_id = "category_id"
        case status = "status"
        case spec_items = "spec_items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        spec_items = try values.decodeIfPresent([Spec_items].self, forKey: .spec_items)
    }

}

struct Spec_items : Codable {
    let id : Int?
    var name : String?
    let spec_group_id : Int?
    let description : String?
    let order : Int?
    let include_in_brief : Bool?
    let status : String?
    let value : String?
    
    init(name: String, value: String) {
        self.name = name
        self.id = 0
        self.spec_group_id = 0
        self.description = ""
        self.order = 0
        self.include_in_brief = false
        self.status = ""
        self.value = value
    }

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case spec_group_id = "spec_group_id"
        case description = "description"
        case order = "order"
        case include_in_brief = "include_in_brief"
        case status = "status"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        spec_group_id = try values.decodeIfPresent(Int.self, forKey: .spec_group_id)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        include_in_brief = try values.decodeIfPresent(Bool.self, forKey: .include_in_brief)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}
