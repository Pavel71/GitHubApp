//
//  DetailsViewController.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


// Итак у нас 2 View которые нужно заполнить данными!


class DetailsViewController : UITableViewController {
  
  var detailViewModel  : DetailScreenViewModel
  
  // Header
  var detailModel : DetailModel
  // List
  var repos       : [Repository]
  
  
  // MARK: - Init
  
  init(detailViewModel : DetailScreenViewModel) {
    self.detailViewModel = detailViewModel
    
    self.detailModel = detailViewModel.detailModel
    self.repos       = detailViewModel.repos
    super.init(style: .plain)
    
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    title = "Details Screen"
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureTableView() {
    tableView.register(RepoListCell.self, forCellReuseIdentifier: RepoListCell.cellId)
  }
  
}

// MARK: TableView Delegate and DataSource
extension DetailsViewController {
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RepoListCell.cellId, for: indexPath) as! RepoListCell
    cell.configure(viewModel: repos[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repos.count
  }
}

// MARK: TableView Header 
extension DetailsViewController {
  
}
