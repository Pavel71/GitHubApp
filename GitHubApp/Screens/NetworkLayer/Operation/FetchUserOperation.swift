//
//  FetchUserOperation.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 14.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit

// Моя задача написать операцию которая будет загружать юзеров! Еп макарек! тоесть это одноразоваое дело но с возможностью отмены!

// Вообще Opearations должны быть во ViewModel - Это я буду реализовывать завтра + будет реализация загрузки картинок через operation + кеш + cancel если быстро пролистываем

// Также завтра мне нужно будет реализовать загрузку данных для detail screen
// + анимированные placeholders пока идет загрузкаКуыы


class FetchUsersOperation : AsyncOperation {
  
  // Input
  var userName : String  
  var pages    : Int
  
  
  // Output
  var didLoadedResult : ((Result<UsersSearchResult,GitHubApiError>) -> Void)?
  
   init(userName: String,pages: Int) {
    self.userName = userName
    self.pages    = pages
    super.init()
  }
  
  
  override func main() {
    
    
    // 1
    if isCancelled  { return }
    
    GitHubApi.shared.searchUsers(userName: userName, pages: pages) { (result) in
      // 2
      if  self.isCancelled { return }
      
      self.didLoadedResult!(result)
    }
    
  }
  
}
