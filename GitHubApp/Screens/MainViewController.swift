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
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
      
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
  
  
  // MARK: - Fetch USers
  
  @objc func fetchUsers(text: String) {
    
    self.tableView.tableFooterView = createFooterSpinner()
    
     viewModel.searchUsers(filteringText: text) {[weak self] result in
      
      self?.viewModel.isLoadingData = false
      
      DispatchQueue.main.async {
        self?.tableView.tableFooterView = nil
      }
      
        switch result {
        case .success(let users):
          self?.users = users
        case .failure(let error):
          print(error.localizedDescription)
          DispatchQueue.main.async {
            self?.showAlert(message: error.localizedDescription)
          }
          
        }
      }
   }
  
  // MARK: - Created Footer Spinner
  
  func createFooterSpinner() -> UIView {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    activityIndicator.startAnimating()
    return activityIndicator
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
  
  
  
}
// MARK: - Navigation
extension MainViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = users[indexPath.row]
    print("Fetch user data",user.username)
    
    let detailScreenViewModel = DetailScreenViewModel(userUrl: user.url)
    
    detailScreenViewModel.fetchUser {[weak self] results in
      switch results {
      case .success(let detailModel):
        print(detailModel)
      case .failure(let error):
        self?.showAlert(message: error.localizedDescription)
      }
    }
    
    
  }
}
// MARK: When scrol to Last Cell
extension MainViewController {
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position       = scrollView.contentOffset.y
    let scrollViewLastCell = (tableView.contentSize.height - 100) - scrollView.frame.size.height
    
    guard let text = searchController.searchBar.text else {return}
    if position > scrollViewLastCell && viewModel.isLoadingData == false && text.isEmpty == false {
      viewModel.isLoadingData = true
      print("Fetch New Data")
      
      fetchUsers(text: text)
    }
  }
}


//MARK: - Set SearchController
extension MainViewController : UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    // Нужна проверка на дубликаты чтобы не дублировать запрос дважды
    
    guard
      let text                    = searchController.searchBar.text,
      text.isEmpty                == false
    else {return cleanUsers()}
    
    if  viewModel.currentUserString != text {
      
      viewModel.currentUserString = text
      viewModel.dropPagging()
      perform(#selector(fetchUsers(text: )), with: text, afterDelay: 0.3)
    }
    

  }
  
 
  
  
}
