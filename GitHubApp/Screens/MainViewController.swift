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
    tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.cellId)
    return tableView
  }()
  
  // MARK: ViewModel
  
  var viewModel = MainScreenViewModel()
  private var operations: [IndexPath: Operation] = [:]
  private let queue = OperationQueue()
  
  // MARK: Workers
  
  let imageCash: ImageCachWorker! = ServiceLocator.shared.getService()
  
  // MARK: DataSource
  
  var users : [GitHubUser] = []
  
  // MARK: - Lyfe Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
    addTableView()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    searchController.searchBar.delegate        = self
    navigationItem.searchController            = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  private func addTableView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    
  }
  
  
  // MARK: Fetch By Operation
  
  @objc private  func searchUsersByOperation() {
   
    
    let text = viewModel.currentUserString
    guard text.isEmpty == false else {return}
    
    print("Fetch Data")
    
     self.tableView.tableFooterView = createFooterSpinner()
    
    viewModel.searchUsers(filteringText: text) { (result) in
      
        switch result {
        case .failure(let error):
          print(error,"Network Error")
//          self.showAlert(message: error.localizedDescription)
          RunLoop.main.perform(inModes: [.common]) {[weak self] in
            self?.dismissFooterIndicator()
          }
        case .success(let users):

          
          self.users = users
          
          RunLoop.main.perform(inModes: [.common]) {[weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.dismissFooterIndicator()
            self.viewModel.isSearchingUsers = false
          }
          
        }
        
        
        
      
    }
    
  }
  
  private func getDiffusers(newUsers: [GitHubUser]) -> [GitHubUser] {

    return newUsers.filter{self.users.contains($0) == false}
  }


  private func calculateIndexPathsToReload(from newUsers: [GitHubUser]) -> [IndexPath] {

    let startIndex = users.count
    let endIndex = users.count  + newUsers.count

    print(startIndex,endIndex,"Indexes")
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
  }
  
  
  
  
  
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
        self.imageCash.setImage(image: image!, key: url.absoluteString)
        // Обновим ячеечку
        cell.updateImageViewWhenLoaded(image)
        
      }
    }
    
  }
  
  
}


// MARK: - TableView  DataSource

extension MainViewController: UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.cellId, for: indexPath) as! UserListCell
    
    let user = users[indexPath.row]
    cell.configure(viewModel: user)
    
    // Если есть в кеше то достаем оттуда
    if let imageFromCache = imageCash.getImage(key: user.avatarUrl.absoluteString) {
      print("из кешика")
      cell.setImageToAvatarImageView(imageFromCache)

    }
    
    return cell
  }
  
   

  
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  
  
}

// MARK: - TableView  Delegate

extension MainViewController: UITableViewDelegate {
  
  
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let operation = viewModel.avatarLoadedInProgress[indexPath] {
      print("Cancel Oper,",indexPath)
          operation.cancel()
          viewModel.avatarLoadedInProgress.removeValue(forKey: indexPath)
        }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    let user = users[indexPath.row]
    
    // в кеше нет картинки
     if imageCache.object(forKey: user.avatarUrl.absoluteString as NSString) == nil {
//      print("Load Ava WIll Display",indexPath)
      loadAvatarImage(url: user.avatarUrl, indexPath: indexPath)
       }
    
  }
  

}
// MARK: - Route
extension MainViewController {
  
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
//    print(indexPath,"Selected \(self.users[indexPath.row].username)")
    
    let userName        = self.users[indexPath.row].username
    routToDetailViewCOntroller(userName: userName)
    

  }
  
  
  private func routToDetailViewCOntroller(userName: String ) {
    let detailViewModel = DetailScreenViewModel(userName: userName)
    let detailVC        = DetailsViewController(detailViewModel: detailViewModel)
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
}

 // MARK: - Created Footer Spinner
extension MainViewController {

  
 
  
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
//    print(indexPath.row ,viewModel.getPagging())
    return viewModel.getPagging() - 1 <= indexPath.row
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
      // тут нужно отменить операцию спрева если срабатывает запрос несколько раз
     if viewModel.isSearchingUsers == false {
        viewModel.isSearchingUsers = true
        self.viewModel.incrementPagging()
        searchUsersByOperation()
      }
      
    }
  }
  // Отмена
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    
    indexPaths.forEach {
      if let operation = viewModel.avatarLoadedInProgress[$0] {
        operation.cancel()
        viewModel.avatarLoadedInProgress.removeValue(forKey: $0)
      }
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
