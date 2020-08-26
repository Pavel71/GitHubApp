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
  
//  var userUrl   : URL
//  var reposUrl  : URL
  var userName  : String
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  var dispatchGroup = DispatchGroup()
  
  init(userName: String) {
    self.userName = userName
//    self.userUrl  = userUrl
//    self.reposUrl = reposUrl
  }
  
  // MARK: - Fetch Detail Screen Model
  func fetchDetailScreenData(complatition: @escaping (Result<Bool,GitHubApiError>) -> Void) {
    

    dispatchGroup.enter()

//    print("Загрузка Юзеров")
      self.fetchUser { (result) in
        
//     print("Загрузка Юзеров законченна")
        switch result {
        case .success(let detailModel):
//          print(detailModel)
//          print("Загрузка Юзеров законченна успешно")
          self.detailModel = detailModel
        case .failure(let error):
//          print("Загрузка Юзеров законченна с ошибкой")
          self.error = error
        }
        self.dispatchGroup.leave()

      }

    dispatchGroup.enter()
//    print("Async code")


//     print("Загрузка Repos")
      self.fetchRepos{ (result) in
        
//        print("Загрузка Repos законченна")
        switch result {
        case .success(let repos):
//          print(repos)
          self.repos = repos
        case .failure(let error):
          self.error = error
        }
        self.dispatchGroup.leave()
      }

    dispatchGroup.notify(queue: .main) {
      print("Загрузка всех данных Загрузились")
      DispatchQueue.main.async {
        if let error = self.error {
          
          complatition(.failure(error))
          
        } else {
          
          let detailScreenModel = DetailScreenModel(details: self.detailModel, repos: self.repos)
          self.detailScreenModel = detailScreenModel
          complatition(.success(true))
          
        }
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
