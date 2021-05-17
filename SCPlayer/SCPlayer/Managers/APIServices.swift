//
//  APIServices.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 11/05/2021.
//

import Foundation

final class APIServices {
    
    static let shared = APIServices()
    
    public func fetchTracksJSON(completion: @escaping (Result<[Track], Error>) -> Void) {
        let urlString = URLString.tracks.url
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                guard let data = data else { return }
                let courses = try JSONDecoder().decode([Track].self, from: data)
                completion(.success(courses))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}
