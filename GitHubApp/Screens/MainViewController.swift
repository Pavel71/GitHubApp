//
//  MainViewController.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


class MainViewController: UITableViewController {
  
  // MARK: Outlets
  
  let searchController : UISearchController = {
    let sc = UISearchController(searchResultsController:nil)
    sc.obscuresBackgroundDuringPresentation = false
    sc.searchBar.placeholder = "Search for a GitHub user..."
    sc.searchBar.becomeFirstResponder()
    return sc
  }()
  var currentSearchText = ""
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  
  // MARK: - Lyfe Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .yellow
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchController.searchResultsUpdater      = self
    navigationItem.searchController            = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
}

//MARK: - Set SearchController
extension MainViewController : UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    // Нужна проверка на дубликаты чтобы не дублировать запрос дважды
    guard
      let text          = searchController.searchBar.text,
      text.isEmpty      == false,
      currentSearchText != text
    else {return}
    currentSearchText = text
    
    gitHubApi.fetchUsers(userName: text) { result in
      
      switch result {
      case .success(let userSearchResult):
        print(userSearchResult)
      case .failure(let error):
        self.showAlert(title: "Что-то пошло не так", message: error.localizedDescription)
      }
      
      
    }
  }
  
  
}
