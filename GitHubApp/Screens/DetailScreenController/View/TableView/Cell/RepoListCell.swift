//
//  RepoListCell.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


protocol RepoListCellable {
  var name: String {get set}
}

class RepoListCell : UITableViewCell {
   
  static let cellId = "RepoListCell"
  
  private let repoNameLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.systemFont(ofSize: 20)
    return l
  }()
    // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set Views
extension RepoListCell {
  func setViews() {
    let hStack = UIStackView(arrangedSubviews: [repoNameLabel,UIView()])
    hStack.distribution = .fillEqually
    hStack.axis         = .horizontal
    addSubview(hStack)
    hStack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
}

// MARK: Set ViewModel
extension RepoListCell {
  
  
  func configure(viewModel:RepoListCellable) {
    self.repoNameLabel.text = viewModel.name
  }
}
