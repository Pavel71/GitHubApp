//
//  DetailScreenViewModel.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation


final class DetailScreenViewModel {
  
  var detailScreenModel : DetailScreenModel?
  
  var userUrl   : URL
  var reposUrl  : URL
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  var dispatchGroup = DispatchGroup()
  
  init(userUrl: URL,reposUrl: URL) {
    self.userUrl  = userUrl
    self.reposUrl = reposUrl
  }
  
  // MARK: - Fetch Detail Screen Model
  func fetchDetailScreenData(complatition: @escaping (Result<DetailScreenModel,GitHubApiError>) -> Void) {
  
    dispatchGroup.enter()
    print("Загрузка User")
    fetchUser { (result) in
      self.dispatchGroup.leave()
      print("загрузка User Completed")
    }
    print("Ждем??")
    dispatchGroup.enter()
    print("Загрузка Repos")
    fetchRepos{ (result) in
      self.dispatchGroup.leave()
      print("загрузка Repos Completed")
    }
    
    dispatchGroup.notify(queue: .main) {
      print("Загрузка всех данных закончилась")
    }
  }
  
  // MARK: - Fetch User
  private func fetchUser(complatition: @escaping (Result<DetailModel,GitHubApiError>) -> Void) {
    
    gitHubApi.fetchUserByUrl(url: userUrl, completion: complatition)
  }
  // MARK: - Fetch Repos
  private func fetchRepos(complatition: @escaping (Result<[Repository],GitHubApiError>) -> Void) {
    
    gitHubApi.fetchReposByUrl(url: reposUrl, completion: complatition)
  }
}
