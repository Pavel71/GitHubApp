//
//  UserListCell.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit

protocol UserListCellable {
  var username    : String   {get set}
  var type        : String   {get set}
  var avatarUrl   : URL      {get set}
  
}

// Здесь нам нужно получить урл аватарки и загрузить его в эту конкретную ячейку!

class UserListCell: UITableViewCell {
  
  static let cellId = "UserListCell"
  
  // MARK: Outlets
  
  var nameLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.systemFont(ofSize: 20)
    return l
  }()
  
  var typeLabel : UILabel = {
    let l = UILabel()
    l.font = UIFont.systemFont(ofSize: 18)
    return l
  }()
  
  var avatarImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "avatarPlaceholder"))
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  var imageLoaderWithCache : ImageLoaderCache! = ServiceLocator.shared.getService()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set Up Views
extension UserListCell{
  
  func setViews() {
    
    let vStack = UIStackView(arrangedSubviews: [nameLabel,typeLabel])
    vStack.distribution = .fillEqually
    vStack.axis         = .vertical
    vStack.spacing      = 5
    
    let hStack = UIStackView(arrangedSubviews: [avatarImageView,vStack])
    hStack.distribution = .fillEqually
    hStack.axis         = .horizontal
    hStack.spacing      = 5
    
    avatarImageView.constrainWidth(constant: 50)
    avatarImageView.constrainHeight(constant: 100)
    
    addSubview(hStack)
    hStack.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    
  }
}

// MARK: Configure Cell
extension UserListCell {
  func configure(viewModel: UserListCellable) {
    nameLabel.text = viewModel.username
    typeLabel.text = viewModel.type
    
    imageLoaderWithCache.loaderFor(user: viewModel).fetchImage(for: viewModel.avatarUrl) { [weak self] image in
      self?.avatarImageView.image = image
      self?.avatarImageView.roundCornersForAspectFit(radius: 15)
    
    }
  }
}