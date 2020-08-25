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
  
  let loadingActivityIndicator = LoadingActivityIndicator(frame: .init(x: 0, y: 0, width: 100, height: 100))
  
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
    setLoadingActivitIndicator()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchController.searchBar.delegate        = self
//    searchController.searchResultsUpdater      = self
    navigationItem.searchController            = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  
  // MARK: - Fetch USers
  
  @objc func fetchUsers() {
    
   
    let text = viewModel.currentUserString
    
    guard text.isEmpty == false else {return}
    
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
    viewModel.currentUserString = ""
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
    
    showLoadingActivitIndicator()
    viewModel.routToDetailScreenController(indexPath: indexPath) {[weak self] result in
      
      switch result {
      case .failure(let error):
        self?.showAlert(message: error.localizedDescription)
      case .success(_):
        
        let detailViewController = DetailsViewController(detailViewModel: (self?.viewModel.detailScreenViewModel)!)
        self?.navigationController?.pushViewController(detailViewController, animated: true)
      }

       self?.dismisLoadingActivtiIndiactor()
    }
  }
}

// MARK: -  Activity Indicators
extension MainViewController {
  func setLoadingActivitIndicator() {
    view.addSubview(loadingActivityIndicator)
    loadingActivityIndicator.center   = view.center
    loadingActivityIndicator.isHidden = true
  }
  
  func showLoadingActivitIndicator() {
    loadingActivityIndicator.activityIndicator.startAnimating()
    loadingActivityIndicator.isHidden = false
  }
  func dismisLoadingActivtiIndiactor() {
   
      self.loadingActivityIndicator.activityIndicator.stopAnimating()
      self.loadingActivityIndicator.isHidden = true
    
    
    
  }
  
  // MARK: - Created Footer Spinner
  
  func createFooterSpinner() -> UIView {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    activityIndicator.startAnimating()
    return activityIndicator
  }
}
// MARK: When scrol to Last Cell
extension MainViewController {
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position       = scrollView.contentOffset.y
    let scrollViewLastCell = (tableView.contentSize.height - 100) - scrollView.frame.size.height
    
    guard let text = searchController.searchBar.text else {return}
    
    if position > scrollViewLastCell && viewModel.isLoadingData == false && text.isEmpty == false {
      viewModel.isLoadingData     = true
      viewModel.currentUserString = text
      
      fetchUsers()
    }
  }
}


// MARK: - Set SearchController
// UISearchResultsUpdating
extension MainViewController :  UISearchBarDelegate{
  
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
    cleanUsers()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    viewModel.currentUserString = searchText
    
    if searchText.isEmpty {
      
      cleanUsers()
      
    } else {
      viewModel.dropPagging()
      
      NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchUsers), object: searchBar)
      perform(#selector(self.fetchUsers), with: searchBar, afterDelay: 0.75)
    }
    
    
    

  }
 
  
  
}
