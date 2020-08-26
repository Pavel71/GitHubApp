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
  var reposUrl    : URL      {get set}
  
}

// Здесь нам нужно получить урл аватарки и загрузить его в эту конкретную ячейку!

class UserListCell: UITableViewCell {
  
  static let cellId = "UserListCell"
  
  // MARK: Views
  
  private var nameLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.systemFont(ofSize: 20)
    return l
  }()
  
  private var typeLabel : UILabel = {
    let l = UILabel()
    l.font = UIFont.systemFont(ofSize: 18)
    return l
  }()
  
  private var avatarImageView: AsyncLoadedImageView = {
    let iv = AsyncLoadedImageView(image: #imageLiteral(resourceName: "avatarPlaceholder"))
    iv.contentMode = .scaleAspectFit
    
    return iv
  }()
  
  // MARK: - Stacks
  private lazy var titlesVStackView : UIStackView = {
    let vStack = UIStackView(arrangedSubviews: [nameLabel,typeLabel])
    vStack.distribution = .fillEqually
    vStack.axis         = .vertical
    vStack.spacing      = 5
    return vStack
  }()
  
  private lazy var stackView: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [avatarImageView,titlesVStackView])
    hStack.distribution = .fill
    hStack.axis         = .horizontal
    hStack.spacing      = 20
    return hStack
  }()
  
 
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setStackView()

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set Up Views
extension UserListCell{
  
  func setStackView() {
    addSubview(stackView)
    avatarImageView.constrainWidth(constant: 100)
    stackView.fillSuperview(padding: .init(top: 10, left: 16, bottom: 10, right: 16))
  }
  
}

// MARK: Configure Cell
extension UserListCell {
  
  func configure(viewModel: UserListCellable) {
    nameLabel.text = viewModel.username
    typeLabel.text = viewModel.type
    
    self.avatarImageView.loadImageUsingUrl(url: viewModel.avatarUrl) { [weak self] isLoaded in
      self?.avatarImageView.roundCornersForAspectFit(radius: 15)
    }
    
  }
}
