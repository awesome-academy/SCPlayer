//
//  UIImageView++.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 17/05/2021.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImage(urlString: String?) {
        
        let defaultUrlAvatar = "https://i1.sndcdn.com/avatars-000095532295-z1dc70-large.jpg"
        let urlString = urlString ?? defaultUrlAvatar
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }

        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                print("Couldn't download image: \(String(describing: error))")
                return
            }
            imageCache.setObject(image, forKey: urlString as AnyObject)
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
