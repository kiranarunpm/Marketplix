//
//  ChatHistoryModel.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import Foundation

struct ChatHistoryResponse : Codable {
    let chats : [Chats]?
    let blocked : Int?
}

struct Chats : Codable {
    let id : Int?
    let title : String?
    let participant_a : String?
    let participant_b : String?
    let created_at : String?
    let updated_at : String?
    let message : String?
    let classifieds : Classifieds?
    let chats : [Chats]?
    let sender : Sender?
    let chats_count: String?
    let blocked: String?
    
}

struct Classifieds : Codable {
    let id : Int?
    let title : String?
    let is_fav : Int?
    let time_diff : String?

}

struct Sender : Codable {
    let id : Int?
    let first_name : String?
}


struct ChatIniateResponse : Codable {
    let message : String?
    let chat_details : Chat_details?
}

struct Chat_details : Codable {
    let title : String?
    let updated_at : String?
    let created_at : String?
    let id : Int?
    let chats : [Chats]?
}

struct ChatDetailsResponse : Codable {
    let chat_details : Chats?
    let blocked : String?
}



struct ChatCountResponse : Codable {
    let chat_count : Int?
}
struct BlockResponse: Codable{
    let chat : BlockResponseChat?
}
struct BlockResponseChat: Codable{
    let blocked : Int?
}
