//
//  MainScreenViewModel.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


// Класс отвечает за взаимодействие Сетевого слоя и ViewController


// Сейчас стоит задача настроить загрузку погинациями! При подгрузуее новых данных нужно будет брать массив и аппендить его конец! А соотвественно когда мы пользуемся поиском то все эти настройик сбрасываются

final class MainScreenViewModel {
  
  
  // MainScreenPropertys
  var users   : [GitHubUser] = []

  private var pagging       : Int    = 21
  private var totalCount    : Int    = 0
  

  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  var currentUserString      = ""
  var isSearchingUsers       = false
  
  //MARK: - Search Operation
  var loadQueue = OperationQueue()
  var fetchUsersOperation: FetchUsersOperation!
  
  //MARK:  - Load AvatarImage
  
  
  var avatarLoadedInProgress: [IndexPath: Operation] = [:]
  
  var avatarDownloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Avatars Download Queue"
        return queue
    }()
    
    
  
  
  
  
  
  // DetailScreenViewModel
  
  private var detailScreenViewModel : DetailScreenViewModel!
  

  
  // MARK: Load Avatar Images
  
  func loadAvatarImage(url: URL,indexPath: IndexPath, complation: @escaping ((UIImage?) -> Void) ) {
    

    
    let downloadOp = AvatarImagesLoadedOperation(imageUrl: url)
    
    downloadOp.didLoadedImage = { image in
      complation(image)
      self.avatarLoadedInProgress[indexPath] = nil
    }
    avatarDownloadQueue.addOperation (downloadOp)
    avatarLoadedInProgress[indexPath] = downloadOp
  }
  func cancelAllAvatarDownLoadOperations() {
      avatarDownloadQueue.cancelAllOperations()
      avatarLoadedInProgress = [:]
  }
  
  // MARK: - Search Users
  
  func searchUsers(filteringText: String,complatition: @escaping (Result<[GitHubUser],GitHubApiError>) -> Void) {
    
    if fetchUsersOperation != nil { // Отменяем старую операцию если она есть
      loadQueue.cancelAllOperations()
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
  
  func cancelSearchingUsersOperation() {
    if fetchUsersOperation != nil { // Отменяем старую операцию если она есть
      loadQueue.cancelAllOperations()
    }
  }
  

  // MARK: - Pagging
  func dropPagging() {
    pagging = 21
  }
  func incrementPagging() {
    pagging += 21
  }
  func getPagging() -> Int {
    return pagging
  }
  
  func resetRequestProperty() {
    
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
