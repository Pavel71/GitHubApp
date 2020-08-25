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
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  
  init(userUrl: URL) {
    self.userUrl = userUrl
  }
  
  
  func fetchUser(complatition: @escaping (Result<DetailScreenModel,GitHubApiError>) -> Void) {
    
    gitHubApi.fetchUserByUrl(url: userUrl, completion: complatition)
  }
}
