//
//  DetailHeaderView.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit

protocol DetailHeaderViewable {
  var avatarUrl   : URL     {get set}
  var login       : String  {get set}
  var name        : String? {get set}
  var createdAt   : String  {get set}
  var location    : String? {get set}
}

class DetailHeaderView: UIView {
  
  // MARK: - Views
  
  private var avatarImageView: AsyncLoadedImageView = {
    let iv = AsyncLoadedImageView(image: #imageLiteral(resourceName: "avatarPlaceholder"))
    iv.contentMode        = .scaleAspectFit
    return iv
  }()
  
  // MARK: - Stacks
  
  private lazy var stack: UIStackView = {
    let vStack = UIStackView(arrangedSubviews: [avatarImageView,UIView()])
        vStack.axis         = .vertical
        vStack.distribution = .fill
    return vStack
  }()
  
  
    // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = #colorLiteral(red: 0.9491460919, green: 0.9487624764, blue: 0.9704342484, alpha: 1)
    setViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Set Views
extension DetailHeaderView {
  
  func setViews() {
    
    addSubview(stack)
    stack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    avatarImageView.constrainHeight(constant: 150)

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
