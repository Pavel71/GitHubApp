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
  
  // MARK: ViewModel
  
  var viewModel = MainScreenViewModel()
  
  // MARK: DataSource
  
  var users : [GitHubUser] = [] {
    didSet {
      self.tableView.reloadData()
    }
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
  
  @objc func fetchUsers(text: String) {
     viewModel.fetchUser(filteringText: text) { result in
        
        switch result {
        case .success(let users):
          self.users = users
        case .failure(let error):
          print(error.localizedDescription)
          
          DispatchQueue.main.async {
            self.showAlert(message: error.localizedDescription)
          }
          
        }
      }
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
  
  private func cleanUsers() {
    self.users.removeAll()
    tableView.reloadData()
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
  
  // MARK: When scrol to Last Cell
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == users.count - 1 {
      print("Last Cell")
      guard let text = searchController.searchBar.text else {return}
      
      perform(#selector(fetchUsers(text: )), with: text, afterDelay: 0.1)
//
//      viewModel.fetchUser(filteringText: text) { (result) in
//        switch result {
//        case .success(let users):
//          print("ExtraUsers",users.count)
//          self.users = users
//        case .failure(let error):
//          print("error")
//          DispatchQueue.main.async {
//            self.showAlert(message: error.localizedDescription)
//          }
////          self.showAlert(message: error.localizedDescription)
//        }
//      }
      
    }
  }
}


//MARK: - Set SearchController
extension MainViewController : UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    // Нужна проверка на дубликаты чтобы не дублировать запрос дважды
    guard
      let text          = searchController.searchBar.text,
      text.isEmpty      == false
      
      else {return cleanUsers()}
    
    viewModel.dropPagging()
    perform(#selector(fetchUsers(text: )), with: text, afterDelay: 0.3)

  }
  
 
  
  
}
