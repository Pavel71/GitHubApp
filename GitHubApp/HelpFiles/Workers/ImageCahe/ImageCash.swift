//
//  ImageCash.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 16.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


final class ImageCachWorker {
  
  // ПО идеи это нужно сделать потоко безопасно! как мне кажется!
  static let shared  = ImageCachWorker()
  
  private let imageCache = NSCache<NSString, UIImage>()
  
  func setImage(image: UIImage,key: String) {
    imageCache.setObject(image, forKey: key as NSString)
  }
  
  func getImage(key: String) -> UIImage? {
    return imageCache.object(forKey: key as NSString)
  }
  
  func clearCash() {
    imageCache.removeAllObjects()
  }
  
}
