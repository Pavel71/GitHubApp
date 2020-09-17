//
//  DetailScreenViewModel.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation


final class DetailScreenViewModel {
  
  var detailScreenModel : DetailScreenModel!
  
  var detailModel       : DetailModel!
  var repos             : [Repository] = []
  var error             : GitHubApiError?
  

  var userName  : String
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  let dispatchGroup = DispatchGroup()
  
  init(userName: String) {
    self.userName = userName
  }
  
  // MARK: - Fetch Detail Screen Model
  func fetchDetailScreenData(complatition: @escaping (Result<DetailScreenModel,GitHubApiError>) -> Void) {

      print("Загрузка Юзеров")
    
    self.dispatchGroup.enter()
    
    self.fetchUser {[weak self]  (result) in
      guard let self = self else {return}
      
      defer {self.dispatchGroup.leave()}
      switch result {
      case .success(let detailModel):
        
        print("Загрузка Юзеров законченна успешно")
        self.detailModel = detailModel
      case .failure(let error):
        
        self.error = error
      }
            
    }
    self.dispatchGroup.enter()
    print("Загрузка repos")
    
    self.fetchRepos{[weak self]  (result) in
      guard let self = self else {return}
      defer {self.dispatchGroup.leave()}
      
      print("Загрузка Repos законченна")
      switch result {
      case .success(let repos):
        self.repos = repos
      case .failure(let error):
        self.error = error
      }
      
    }
    
    dispatchGroup.notify(queue: .main) {[weak self] in
      print("Загрузка всех данных Загрузились")
      guard let self = self else {return}
      
          if let error = self.error { complatition(.failure(error))}
          
          else {
            
            let detailScreenModel = DetailScreenModel(details: self.detailModel, repos: self.repos)
            
            complatition(.success(detailScreenModel))
            
        }
    }
    
    
    
  }
  
  // MARK: - Fetch User
  private func fetchUser(complatition: @escaping (Result<DetailModel,GitHubApiError>) -> Void) {
    gitHubApi.fetchUser(userName: userName, completion: complatition)

  }
  // MARK: - Fetch Repos
  private func fetchRepos(complatition: @escaping (Result<[Repository],GitHubApiError>) -> Void) {
    gitHubApi.fetchRepos(userName: userName, completion: complatition)

  }
}
