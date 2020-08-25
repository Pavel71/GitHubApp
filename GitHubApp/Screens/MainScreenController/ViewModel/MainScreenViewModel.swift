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
  
  
  var pagging : Int          = 0
  var isLoadingData          = false
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  var currentUserString      = ""

  
  
  func searchUsers(filteringText: String,complatition: @escaping (Result<[GitHubUser],GitHubApiError>) -> Void) {

    incrementPagging()
    
    gitHubApi.searchUsers(userName: filteringText, pages: pagging) { result in
          
          switch result {
          case .success(let userSearchResult):
            complatition(.success(userSearchResult.users))
          case .failure(let error):
            complatition(.failure(error))
            
          }
          
          
        }
  }

  
  func dropPagging() {
    pagging = 0
  }
  func incrementPagging() {
    pagging += 15
  }
  
}
