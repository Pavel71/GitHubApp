//
//  DetailHeaderView.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit

protocol DetailHeaderViewable {
  var avatarUrl : URL {get set}
}

class DetailHeaderView: UIView {
  
  var avatarImageView: AsyncLoadedImageView = {
    let iv = AsyncLoadedImageView(image: #imageLiteral(resourceName: "avatarPlaceholder"))
    iv.contentMode        = .scaleAspectFit
    return iv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Set Views
extension DetailHeaderView {
  
  func setViews() {
    
    setAvatarImageView()
    
//    let avatarContanerView = UIView()
//
//    avatarContanerView.addSubview(avatarImageView)
//    avatarImageView.fillSuperview()
//    avatarImageView.constrainHeight(constant: 150)
//
//    let vStack = UIStackView(arrangedSubviews: [avatarContanerView])
//    vStack.axis         = .vertical
//    vStack.distribution = .fill
//
//
//    addSubview(vStack)
//    vStack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
  
  func setAvatarImageView() {
    let avatarContanerView = UIView()
    
    avatarContanerView.addSubview(avatarImageView)
    avatarImageView.fillSuperview()
    
    avatarImageView.constrainHeight(constant: 150)
    
    addSubview(avatarContanerView)
    avatarContanerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    
  }
}


// MARK: - set ViewModel
extension DetailHeaderView {
  
  func configure(viewModel:DetailHeaderViewable) {
    
    avatarImageView.loadImageUsingUrl(url: viewModel.avatarUrl) { (_) in
          self.avatarImageView.roundCornersForAspectFit(radius: 15)
    }
    
    
  }
  

}
