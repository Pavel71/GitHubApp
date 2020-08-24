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
    guard let text = searchController.searchBar.text else {return}
    print(text)
  }
  
  
}
