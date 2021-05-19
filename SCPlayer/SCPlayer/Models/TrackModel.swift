//
//  TrackModel.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 11/05/2021.
//

import Foundation
import Then

struct Track: Codable, Then {
    let trackID: Int?
    let genre: String?
    let title: String?
    let permalinkUrl: String?
    let streamURL: String?
    let user: User?
    var isLiked: Bool
    enum SongKeys: String, CodingKey {
        case trackID = "id"
        case genre = "genre"
        case title = "title"
        case permalinkUrl = "permalink_url"
        case streamURL = "stream_url"
        case user = "user"
        case isLiked
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKeys.self)
        trackID = try container.decode(Int?.self, forKey: .trackID)
        title = try container.decode(String?.self, forKey: .title)
        genre = try container.decode(String?.self, forKey: .genre)
        permalinkUrl = try container.decode(String?.self, forKey: .permalinkUrl)
        streamURL = try container.decode(String?.self, forKey: .streamURL)
        user = try container.decode(User?.self, forKey: .user)
        isLiked = false
    }
}
