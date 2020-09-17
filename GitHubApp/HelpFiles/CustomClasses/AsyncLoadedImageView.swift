//
//  AsyncLoadedImageView.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit




//class AsyncLoadedImageView: UIImageView {
////    let imageCache = NSCache<NSString, UIImage>() // this should be in Global var
//    var imageUrl: URL?
//
//  func loadImageUsingUrl(url: URL,completion: @escaping (Bool) -> Void) {
//
//
//      imageUrl = url
//      image = #imageLiteral(resourceName: "avatarPlaceholder").resizeImage(100, opaque: true)
//
//      if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
//            self.image = imageFromCache
//            completion(true)
//
//        }
//
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
//
//            if error != nil {
//                print(error ?? "")
//                return
//            }
//
//            DispatchQueue.main.async {
//              guard let imageToCache = UIImage(data: data!)?.resizeImage(100, opaque: true) else { return }
//
//                if self.imageUrl == url {
//                  self.image = imageToCache
//                  completion(true)
//                }
//
//              self.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
//            }
//
//        }).resume()
//    }
//
//}
