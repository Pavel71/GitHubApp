//
//  MainScreenViewModel.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation


// Класс отвечает за взаимодействие Сетевого слоя и ViewController


// Сейчас стоит задача настроить загрузку погинациями! При подгрузуее новых данных нужно будет брать массив и аппендить его конец! А соотвественно когда мы пользуемся поиском то все эти настройик сбрасываются

final class MainScreenViewModel {
  
  
  // MainScreenPropertys
  var users   : [GitHubUser] = [] {
    didSet {wasUsersCount = users.count}
  }
  var wasUsersCount : Int    = 0
  var pagging       : Int    = 0
  var totalCount    : Int    = 0
  
  var isLoadingData          = false
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  var currentUserString      = ""
  
  // DetailScreenViewModel
  
  private var detailScreenViewModel : DetailScreenViewModel!
  

  
  // MARK: - Search Users
  
  func searchUsers(filteringText: String,complatition: @escaping (Result<[GitHubUser],GitHubApiError>) -> Void) {
    
    if (pagging < totalCount && pagging < 100) || pagging == 0 {
      
      incrementPagging()
      gitHubApi.searchUsers(userName: filteringText, pages: pagging) { result in
        
        switch result {
        case .success(let userSearchResult):
          self.users      = userSearchResult.users
          self.totalCount = userSearchResult.totalCount
          
          complatition(.success(userSearchResult.users))
        case .failure(let error):
          complatition(.failure(error))
        }
        
        
      }
    } else {
      complatition(.failure(.paggingError))
    }
    
    
  }

  // MARK: - Pagging
  func dropPagging() {
    pagging = 0
  }
  func incrementPagging() {
    pagging += 15
  }
  
  func resetRequestProperty() {
    dropPagging()
    totalCount        = 0
    currentUserString = ""
  }
  
}

// MARK: - Get DetailViewModel
extension MainScreenViewModel {
  
  
  func getDetailViewModel(indexPath: IndexPath,completion: @escaping (Result<DetailScreenViewModel,GitHubApiError>) -> Void) {
    
    let user = users[indexPath.row]
       
    detailScreenViewModel = DetailScreenViewModel(userName: user.username)
       
       detailScreenViewModel.fetchDetailScreenData {(result) in
        
         switch result {
         case .failure(let error):
          completion(.failure(error))
          
         case .success(_):
          completion(.success(self.detailScreenViewModel))

         }
         
       }
  }
}
