//
//  URLString.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 11/05/2021.
//

import Foundation

let baseURL = "https://api.soundcloud.com"
let clientID = APIKey.key.rawValue

enum URLString {
    case tracks
    
    var url: String {
        switch self {
        case .tracks:
            return "\(baseURL)/tracks/?client_id=\(clientID)&limit=200"
        }
    }
}

