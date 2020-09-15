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
    l.translatesAutoresizingMaskIntoConstraints = false
    l.font = UIFont.systemFont(ofSize: 20)
    return l
  }()
  
  private var typeLabel : UILabel = {
    let l = UILabel()
    l.translatesAutoresizingMaskIntoConstraints = false
    l.font = UIFont.systemFont(ofSize: 18)
    return l
  }()
  
//  private var avatarImageView: AsyncLoadedImageView = {
//    let iv = AsyncLoadedImageView(image: #imageLiteral(resourceName: "avatarPlaceholder").resizeImage(100, opaque: true))
//    iv.contentMode = .scaleAspectFit
//    iv.translatesAutoresizingMaskIntoConstraints = false
//    return iv
//  }()
  
  private var avatarImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "avatarPlaceholder").resizeImage(100, opaque: true))
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = .white
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  // MARK: - Stacks
  private lazy var titlesVStackView : UIStackView = {
    let vStack = UIStackView(arrangedSubviews: [nameLabel,typeLabel])
    vStack.translatesAutoresizingMaskIntoConstraints = false
    vStack.distribution = .fillEqually
    vStack.axis         = .vertical
    vStack.spacing      = 5
    return vStack
  }()
  
  private lazy var stackView: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [avatarImageView,titlesVStackView])
    hStack.translatesAutoresizingMaskIntoConstraints = false
    hStack.distribution = .fill
    hStack.axis         = .horizontal
    hStack.spacing      = 20
    return hStack
  }()
  
  // MARK: - Constraints
  

   
   private var stackViewConstraints: [NSLayoutConstraint] {
    [stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
     stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
     stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
     stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
    avatarImageView.widthAnchor.constraint(equalToConstant: 100)
    ]
   }
  
  private var staticConstraints: [NSLayoutConstraint] = []
 
  
  // MARK: - Initializers
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setStackView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setStackView()
  }
  
  
}

// MARK: Set Up Views
extension UserListCell{
  
  func setStackView() {
    
    contentView.addSubview(stackView)

  }
  
  override func updateConstraints() {
    
    if staticConstraints.isEmpty {
      staticConstraints.append(contentsOf: stackViewConstraints)
    NSLayoutConstraint.activate(staticConstraints)
    }
    super.updateConstraints()
  }
  
}

// MARK: Configure Cell
extension UserListCell {
  
  func configure(viewModel: UserListCellable) {
    
    nameLabel.text = viewModel.username
    typeLabel.text = viewModel.type
    
    setNeedsUpdateConstraints()
  }
  
  func updateImageViewWhenLoaded(_ image: UIImage?) {
    
        if let image = image {
          setImageToAvatarImageView(image)
            self.avatarImageView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.avatarImageView.alpha = 1.0
            })
            
        } else {
          self.avatarImageView.image = #imageLiteral(resourceName: "avatarPlaceholder").resizeImage(100, opaque: true)
          self.avatarImageView.alpha = 0.5
        }
    }
  
  func setImageToAvatarImageView(_ image: UIImage) {
    self.avatarImageView.image = image.resizeImage(100, opaque: true)
    self.avatarImageView.roundCornersForAspectFit(radius: 15)
    
  }
  
  override func prepareForReuse() {
    avatarImageView.image = #imageLiteral(resourceName: "avatarPlaceholder").resizeImage(100, opaque: true)
    self.avatarImageView.roundCornersForAspectFit(radius: 15)
    nameLabel.text        = nil
    typeLabel.text        = nil
  }
  
}
