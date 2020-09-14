//
//  FetchUserOperation.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 14.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit

// Моя задача написать операцию которая будет загружать юзеров! Еп макарек! тоесть это одноразоваое дело но с возможностью отмены!




class FetchUsersOperation : AsyncOperation {
  
  // Input
  var userName : String = ""
  var pages    : Int    = 15
  
  // Output
  var users: [GitHubUser] = []
  
  
  override func main() {
    // 1
       if isCancelled { return }
    GitHubApi.shared.searchUsers(userName: userName, pages: pages) { (result) in
      // 2
      if self.isCancelled { return }
      
      switch result {
      case .failure(let error):
        print("Fetch Error",error)
        
      case .success(let userSearchRes):
        
        DispatchQueue.main.async {
          self.users = userSearchRes.users
          self.state = .finished
        }
        
      }
    }
    
  }
  
}
