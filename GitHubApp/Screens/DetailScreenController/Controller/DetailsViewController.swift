//
//  DetailsViewController.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit



protocol DetailsViewControllerModable {
  
  var avatarUrl   : URL           {get set} // Image Будет братся из кеша по URL
  var name        : String        {get set}
  var login       : String        {get set}
  var createdAt   : String        {get set}
  var location    : String?       {get set}
//  var repos       : [Repository]? {get set}
}


class DetailsViewController : UITableViewController {
  
  init(detailModal : DetailsViewControllerModable) {
    super.init(style: .plain)
    
    view.backgroundColor = .red
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
