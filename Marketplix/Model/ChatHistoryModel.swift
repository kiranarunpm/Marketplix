//
//  ChatHistoryModel.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import Foundation

struct ChatHistoryResponse : Codable {
    let chats : [Chats]?
}

struct Chats : Codable {
    let id : Int?
    let type : Int?
    let title : String?
    let classified_id : Int?
    let participant_a : Int?
    let participant_b : Int?
    let created_at : String?
    let updated_at : String?
    let message : String?
    let classifieds : Classifieds?
    let chats : [Chats]?
    let sender : Sender?
    let chats_count: Int?
    
}

struct Classifieds : Codable {
    let id : Int?
    let title : String?
    let is_fav : Int?
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
    let type : Int?
    let title : String?
    let classified_id : Int?
    let participant_a : Int?
    let participant_b : Int?
    let updated_at : String?
    let created_at : String?
    let id : Int?
    let chats : [Chats]?
}

struct ChatDetailsResponse : Codable {
    let chat_details : Chats?
}


