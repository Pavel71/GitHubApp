//
//  MainViewController.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
  
  // MARK: Outlets
  
  let searchController : UISearchController = {
    let sc = UISearchController(searchResultsController:nil)
    sc.obscuresBackgroundDuringPresentation = false
    sc.searchBar.placeholder                = "Search for a GitHub user..."
    sc.definesPresentationContext           = true
    sc.dimsBackgroundDuringPresentation     = false
    sc.hidesNavigationBarDuringPresentation = false
    sc.searchBar.becomeFirstResponder()
    
    return sc
  }()
  
  
  private lazy var tableView : UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    tableView.delegate           = self
    tableView.dataSource         = self
    tableView.prefetchDataSource = self
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()
  
//  let loadingActivityIndicator = LoadingActivityIndicator(frame: .init(x: 0, y: 0, width: 150, height: 100))
  
  // MARK: ViewModel
  
  var viewModel = MainScreenViewModel()
  private var operations: [IndexPath: Operation] = [:]
  private let queue = OperationQueue()
  
  // MARK: App State
  
  let appState: AppState! = ServiceLocator.shared.getService()
  
  // MARK: DataSource
  
  var users : [GitHubUser] = []
  
  // MARK: - Lyfe Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
    configureTableView()
    setLoadingActivitIndicator()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    searchController.searchBar.delegate        = self
    navigationItem.searchController            = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  
  
  // MARK: Fetch By Operation
  
  @objc private  func searchUsersByOperation() {
   
    
    let text = viewModel.currentUserString
    guard text.isEmpty == false else {return}
    
    print("Fetch Data")
    
     self.tableView.tableFooterView = createFooterSpinner()
    
    viewModel.searchUsers(filteringText: text) { (result) in
      RunLoop.main.perform(inModes: [.common]) {[weak self] in
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.showAlert(message: error.localizedDescription)
          self.dismissFooterIndicator()
        case .success(let users):
          self.users = users
          self.dismissFooterIndicator()
          print("Reload Data")
          // вот здесь можно попробовать оптимизировать обновление таблицы!
          self.tableView.reloadData()
        }
        
      }
    }
    
   
  }
  let imageCache = NSCache<NSString, UIImage>()
  // MARK: Load Avatar Image
  private func loadAvatarImage(url: URL,indexPath: IndexPath) {
    
    viewModel.loadAvatarImage(url: url, indexPath: indexPath) {[url,indexPath] (image) in
      
      RunLoop.main.perform(inModes: [.common]) {[weak self] in
        
        guard let self = self else { return }
        guard
          let cell = self.tableView.cellForRow(at: indexPath)
            as? UserListCell
          else {return}
        
        // Сохраним в кешик
        self.imageCache.setObject(image!, forKey: url.absoluteString as NSString)
        // Обновим ячеечку
        cell.updateImageViewWhenLoaded(image)
        
      }
    }
    
  }
  
  
}

// MARK: - TableView Configure
extension MainViewController {
  
  private func configureTableView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    registerTableViewCell()
  }
  
  private func registerTableViewCell() {
    tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.cellId)
  }
  

}

// MARK: - TableView  DataSource

extension MainViewController: UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.cellId, for: indexPath) as! UserListCell
    
    let user = users[indexPath.row]
    cell.configure(viewModel: user)
    
    if let imageFromCache = imageCache.object(forKey: user.avatarUrl.absoluteString as NSString) {
      
      cell.setImageToAvatarImageView(imageFromCache)
        
    } else {
      loadAvatarImage(url: user.avatarUrl, indexPath: indexPath)
    }
    
    cell.configure(viewModel: user)

    return cell
  }

  
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  
  
}

// MARK: - TableView  Delegate

extension MainViewController: UITableViewDelegate {
    // MARK: Cancel Avatar Loaded
   func tableView(_ tableView: UITableView,didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if let operation = viewModel.avatarLoadedInProgress[indexPath] {
      print("Cancel Operation")
        operation.cancel()
    }
  }
}
// MARK: - Navigation
extension MainViewController {
  
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    showLoadingActivitIndicator()
    viewModel.getDetailViewModel(indexPath: indexPath) {[weak self] result in
      
      switch result {
      case .failure(let error):
        self?.showAlert(message: error.localizedDescription)
      case .success(let detailViewModel):
        
        let detailViewController = DetailsViewController(detailViewModel:detailViewModel)
        
        self?.navigationController?.pushViewController(detailViewController, animated: true)
      }

       self?.dismisLoadingActivtiIndiactor()
    }
  }
}

// MARK: -  Activity Indicators
extension MainViewController {
//
  func setLoadingActivitIndicator() {
    appState.setLoadingActivityIndicator()
  }
  
  func showLoadingActivitIndicator() {
    appState.showLoadingActivitIndicator()
  }
  func dismisLoadingActivtiIndiactor() {
    appState.dismisLoadingActivtiIndiactor()
  }
  
  // MARK: - Created Footer Spinner
  
  func createFooterSpinner() -> UIView {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    activityIndicator.startAnimating()
    return activityIndicator
  }
  
  func dismissFooterIndicator() {
    tableView.tableFooterView = nil
  }
}


// MARK: - Prefetcing Api
private extension MainViewController {
  
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
//    print(indexPath.row,viewModel.pagging)
    return indexPath.row >= viewModel.getPagging() - 1
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}

extension MainViewController: UITableViewDataSourcePrefetching {
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
    
    if indexPaths.contains(where: isLoadingCell) {
      // Пора загружать данные
      viewModel.incrementPagging()
      searchUsersByOperation()
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
    
    imageCache.removeAllObjects()
    // Нужно скинуть старые операции
    viewModel.cancelAllAvatarDownLoadOperations()
    viewModel.cancelSearchingUsersOperation() // так как юзер будет вводить новые данные

    viewModel.currentUserString = searchText
    viewModel.dropPagging()

    if searchText.isEmpty {

      cleanUsers()

    } else {

      NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchUsersByOperation), object: searchBar)
      perform(#selector(self.searchUsersByOperation), with: searchBar, afterDelay: 0.75)
      
    }

  }
  
  private func cleanUsers() {

    dismissFooterIndicator()
    viewModel.resetRequestProperty()
    self.users.removeAll()
    
    tableView.reloadData()
  }
 
  
  
}
