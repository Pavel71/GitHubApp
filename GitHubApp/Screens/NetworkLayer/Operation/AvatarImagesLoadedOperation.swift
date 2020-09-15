//
//  AvatarImagesLoadedOperation.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 15.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


final class AvatarImagesLoadedOperation : AsyncOperation {
  
  static var downloadsInProgress: [IndexPath: Operation] = [:]
  
    static var downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Avatars Download Queue"
        return queue
    }()
    
    
    static func cancelAllOperations() {
        downloadQueue.cancelAllOperations()
        downloadsInProgress = [:]
    }
  
  
  private var task: URLSessionDataTask?
  
  // Input
  var imageUrl : URL
  
  // OutPut
  
  var didLoadedImage: ((UIImage?) -> Void)?
  
  
   init(imageUrl: URL) {
    self.imageUrl = imageUrl
    super.init()
  }
  
  
  override func main() {
    if self.isCancelled  { return }
    
    task = URLSession.shared.dataTask(with: imageUrl) { [weak self]
      data, response, error in

      guard let self = self else { return }

      defer { self.state = .finished }

      if self.isCancelled  { return }

      guard error == nil, let data = data else { return }

      self.didLoadedImage!(UIImage(data: data))
    }

    task?.resume()
  }

  override func cancel() {
    super.cancel()
    task?.cancel()
  }
  
  
}
