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

    DispatchQueue.global().async {
      self.fetchUser { (result) in
        self.dispatchGroup.leave()

        switch result {
        case .success(let detailModel):
//          print(detailModel)
          self.detailModel = detailModel
        case .failure(let error):
          self.error = error
        }

      }
    }
// Loading Repos
    dispatchGroup.enter()

    DispatchQueue.global().async {
      self.fetchRepos{ (result) in
        self.dispatchGroup.leave()
        switch result {
        case .success(let repos):
//          print(repos)
          self.repos = repos
        case .failure(let error):
          self.error = error
        }
      }
    }
//
    dispatchGroup.notify(queue: .main) {
      print("Загрузка всех данных Загрузились")
      DispatchQueue.main.async {
        if let error = self.error {
          
          complatition(.failure(error))
          
        } else {
          
          let detailScreenModel = DetailScreenModel(details: self.detailModel!, repos: self.repos)
          self.detailScreenModel = detailScreenModel
          complatition(.success(true))
          
        }
      }

    }
  }
  
  // MARK: - Fetch User
  private func fetchUser(complatition: @escaping (Result<DetailModel,GitHubApiError>) -> Void) {
    gitHubApi.fetchUser(userName: userName, completion: complatition)
//    gitHubApi.fetchUserByUrl(userName: userUrl, completion: complatition)
  }
  // MARK: - Fetch Repos
  private func fetchRepos(complatition: @escaping (Result<[Repository],GitHubApiError>) -> Void) {
    gitHubApi.fetchRepos(userName: userName, completion: complatition)
//    gitHubApi.fetchReposByUrl(url: reposUrl, completion: complatition)
  }
}
