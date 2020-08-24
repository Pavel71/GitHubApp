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
    sc.searchBar.placeholder                = "Search for a GitHub user..."
    sc.definesPresentationContext           = true
    sc.searchBar.becomeFirstResponder()
    return sc
  }()
  var currentSearchText = ""
  let gitHubApi : GitHubApi! = ServiceLocator.shared.getService()
  
  // MARK: DataSource
  
  var users : [GitHubUser] = [] {
    didSet {tableView.reloadData()}
  }
  
  // MARK: - Lyfe Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
    configureTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchController.searchResultsUpdater      = self
    navigationItem.searchController            = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  
}

// MARK: - TableView Configure
extension MainViewController {
  
  private func configureTableView() {
    registerTableViewCell()
  }
  
  private func registerTableViewCell() {
    tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.cellId)
  }
}

// MARK: - TableView Delegate and DataSource

extension MainViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.cellId, for: indexPath) as! UserListCell
    cell.configure(viewModel: users[indexPath.row])

    return cell
  }

  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
}

// MARK: ScrollView Did Dragging Down
extension MainViewController {
  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView.contentOffset.y > scrollView.contentSize.height / 1.3 {
      print("Load new bach")
    }
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
//        userSearchResult.users
        // Array(userSearchResult.users.prefix(10))
        self.users = userSearchResult.users
      case .failure(let error):
        self.showAlert(title: "Что-то пошло не так", message: error.localizedDescription)
      }
      
      
    }
  }
  
  
}
