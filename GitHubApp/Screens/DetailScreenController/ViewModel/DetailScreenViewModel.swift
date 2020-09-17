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
  var dispatchGroup = DispatchGroup()
  
  init(userName: String) {
    self.userName = userName
  }
  
  // MARK: - Fetch Detail Screen Model
  func fetchDetailScreenData(complatition: @escaping (Result<DetailScreenModel,GitHubApiError>) -> Void) {
    

    
    DispatchQueue.global().async(group: dispatchGroup, qos: .utility) {
      self.dispatchGroup.enter()
      print("Загрузка Юзеров")
          self.fetchUser { (result) in
              
              switch result {
              case .success(let detailModel):
      
                print("Загрузка Юзеров законченна успешно")
                self.detailModel = detailModel
              case .failure(let error):
      
                self.error = error
              }
              self.dispatchGroup.leave()

            }
    }
    
    DispatchQueue.global().async(group: dispatchGroup, qos: .utility) {
      print("Загрузка repos")
      self.dispatchGroup.enter()
       self.fetchRepos{ (result) in
              
        print("Загрузка Repos законченна")
        switch result {
        case .success(let repos):
          self.repos = repos
        case .failure(let error):
          self.error = error
        }
        self.dispatchGroup.leave()
      }
    }

     

    dispatchGroup.notify(queue: .main) {
      print("Загрузка всех данных Загрузились")

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
