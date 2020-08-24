//
//  ImageData.swift
//  MovieSwift
//
//  Created by Tatiana Kornilova on 02/02/2020.
//  Copyright © 2020 Tatiana Kornilova. All rights reserved.
//

import UIKit
import Combine

 //---------------
final class ImageLoaderCache {
    static let shared = ImageLoaderCache()
  
    var loaders: NSCache<NSString, ImageLoader> = NSCache()
    
    func loaderFor(user: UserListCellable) -> ImageLoader {
      
        let key = NSString(string: "\(user.username)")
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            let url = user.avatarUrl
            let loader = ImageLoader (url: url)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }
}
// -----------------

final class ImageLoader {

  var avatarUrl : URL
    // Init with Error
    init(url: URL) {
        self.avatarUrl = url
    }

   // выборка изображения UIImage? с учетом ошибок
  func fetchImage(for  url: URL,completion: @escaping (UIImage) -> Void)  {
 
             
      let session = URLSession.shared
      session.dataTask(with: url) { (data, response, error) in
        if let data = data, let image = UIImage(data: data) {
          DispatchQueue.main.async {
            completion(image)
          }
        }
      } .resume()
                                    
    }
    
    
  }

    /*
        // Init Light
        init(url: URL?) {
                 self.url = url
                 $url
                 .flatMap { (url) -> AnyPublisher<UIImage?, Never> in
                                             self.fetchImage(for: url)
                 }
                 .assign(to: \.image, on: self)
                 .store(in: &self.cancellableSet)
             }

            private func fetchImage(for url: URL?) -> AnyPublisher<UIImage?, Never> {
              guard url != nil/*, image == nil*/ else {
                  return Just(nil).eraseToAnyPublisher()            // 1
              }
              return
                  URLSession.shared.dataTaskPublisher(for: url!)    // 2
                  .map { UIImage(data: $0.data) }                   // 3
                  .replaceError(with: nil)                          // 4
                  .receive(on: RunLoop.main)                        // 5
                  .eraseToAnyPublisher()                            // 6
          }
    private var cancellableSet: Set<AnyCancellable> = []
}*/


