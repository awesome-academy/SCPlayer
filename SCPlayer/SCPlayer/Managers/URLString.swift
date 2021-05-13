//
//  URLString.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 11/05/2021.
//

import Foundation

let baseURL = "https://api.soundcloud.com"
let clientID = "7c8ae3eed403b61716254856c4155475"

enum URLString {
    case tracks
    var url: String {
        switch self {
        case .tracks:
            return "\(baseURL)/tracks/?client_id=\(clientID)&limit=200"
        }
    }
}
