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
  var users   : [GitHubUser] = []

  private var pagging       : Int    = 20
  private var totalCount    : Int    = 0
  
//  var isLoadingData          = false
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  var currentUserString      = ""
  
  // Operations
  var loadQueue = OperationQueue()
  var fetchUsersOperation: FetchUsersOperation!
  
  
  var loadAvatarImagesQueue = OperationQueue()
  
  
  // DetailScreenViewModel
  
  private var detailScreenViewModel : DetailScreenViewModel!
  

  
  // MARK: Load Avatar Images
  
  
  // MARK: - Search Users
  
  func searchUsers(filteringText: String,complatition: @escaping (Result<[GitHubUser],GitHubApiError>) -> Void) {
    
    if fetchUsersOperation != nil { // Отменяем старую операцию если она есть
      fetchUsersOperation.cancel()
    }
    
    // Нельзя загружать больше 100 из за требований APi
    guard (pagging <= 100) else {
      return
        complatition(.failure(.paggingError))
    }
    
    fetchUsersOperation = FetchUsersOperation(userName: filteringText, pages: pagging)
    loadQueue.addOperation(fetchUsersOperation)
    
    fetchUsersOperation.didLoadedResult = {[weak self] result in
      
      switch  result {
      case .failure(let error):
        complatition(.failure(error))
      case .success(let userUpdateResult):
        self?.totalCount = userUpdateResult.totalCount
        complatition(.success(userUpdateResult.users))
      }
    }
  }
  

  // MARK: - Pagging
  func dropPagging() {
    pagging = 20
  }
  func incrementPagging() {
    pagging += 20
  }
  func getPagging() -> Int {
    return pagging
  }
  
  func resetRequestProperty() {
    if fetchUsersOperation != nil { // Отменяем старую операцию если она есть
      fetchUsersOperation.cancel()
    }
    dropPagging()
    totalCount        = 0
    currentUserString = ""
  }
  
}

// MARK: - Get DetailViewModel
extension MainScreenViewModel {
  
  // СЮда нужно просто юзера передавать и все
  
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
