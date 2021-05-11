//
//  UserModel.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 11/05/2021.
//

import Foundation

struct User: Codable {
    let userId: Int?
    let username: String?
    let permalinkUrl: String?
    let avatarUrl: String?
    
    enum UserKeys: String, CodingKey {
        case userId = "id"
        case username = "username"
        case permalinkUrl = "permalink_url"
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        userId = try container.decode(Int?.self, forKey: .userId)
        username = try container.decode(String?.self, forKey: .username)
        permalinkUrl = try container.decode(String?.self, forKey: .permalinkUrl)
        avatarUrl = try container.decode(String?.self, forKey: .avatarUrl)
    }
}
