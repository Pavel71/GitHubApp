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
  // Name
  private lazy var nameTitleLabel    = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Имя:")
  private lazy var nameLabel         = createSimpleLabel(font: .systemFont(ofSize: 18))
  
    // Login
  private lazy var loginTitleLabel       = createSimpleLabel(font: .systemFont(ofSize: 20),text:"Login:")
  private lazy var loginLabel            = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  // Created at
  private lazy var createdTitleLabel     = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Созданн:")
  private lazy var createdLabel: UILabel = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  // Location
  private lazy var locationTitleLabel     = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Локация:")
  private lazy var locationLabel: UILabel = createSimpleLabel(font: .systemFont(ofSize: 18))
  
//  func createSimpleLabel(font: UIFont,text:String? = nil) -> UILabel {
//    let l = UILabel()
//    l.font          = font
//    l.text          = text
//    l.textAlignment = .left
//    l.sizeToFit()
//    return l
//  }
  
  // MARK: - Stacks
  
  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [topHStack,bottomVStack])
        stack.axis         = .vertical
        stack.distribution = .fill
        stack.spacing      = 10
    return stack
  }()
  
  private lazy var topHStack: UIStackView = {
      let hStack = UIStackView(arrangedSubviews: [avatarImageView,rightVStack])
          hStack.axis         = .horizontal
          hStack.distribution = .fill
          hStack.spacing      = 5
      return hStack
    }()
  
  private lazy var rightVStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameStack,loginStack])
        stack.axis         = .vertical
        stack.distribution = .fillEqually
        stack.spacing      = 5
        stack.alignment    = .leading
    return stack
  }()
  private lazy var bottomVStack: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [locationStack,createdStack])
        hStack.axis         = .vertical
        hStack.distribution = .fillEqually
        hStack.spacing       = 5
    return hStack
  }()
  
  
  private lazy var locationStack = createSimpleHStack(view1: locationTitleLabel, view2: locationLabel)
  private lazy var createdStack  = createSimpleHStack(view1: createdTitleLabel, view2: createdLabel)
  private lazy var nameStack     = createSimpleHStack(view1: nameTitleLabel, view2: nameLabel)
  private lazy var loginStack    = createSimpleHStack(view1: loginTitleLabel, view2: loginLabel)
  
//  func createSimpleHStack(view1: UIView,view2: UIView) -> UIStackView {
//    let hStack = UIStackView(arrangedSubviews: [view1,view2])
//    hStack.distribution  = .fill
//    hStack.axis          = .horizontal
//    hStack.spacing       = 5
//    hStack.alignment     = .fill
//    return hStack
//  }
  
//  func createSimpleVStack(view1: UIView,view2: UIView) -> UIStackView {
//    let vStack = UIStackView(arrangedSubviews: [view1,view2])
//    vStack.distribution  = .fillEqually
//    vStack.axis          = .vertical
//    vStack.spacing       = 5
//    return vStack
//  }
  
  
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
    
    avatarImageView.constrainWidth(constant: 100)
    avatarImageView.constrainHeight(constant: 100)
    
    [locationTitleLabel,createdTitleLabel] .forEach { (label) in
      label.constrainWidth(constant: 100)
    }
    
    [nameTitleLabel,loginTitleLabel] .forEach { (label) in
      label.constrainWidth(constant: 60)
    }
    

  }
  
}


// MARK: - set ViewModel
extension DetailHeaderView {
  
  func configure(viewModel:DetailHeaderViewable) {
    
    avatarImageView.loadImageUsingUrl(url: viewModel.avatarUrl) { (_) in
          self.avatarImageView.roundCornersForAspectFit(radius: 15)
    }
    
    nameLabel.text     = viewModel.name     ?? "--//--"
    loginLabel.text    = viewModel.login
    locationLabel.text = viewModel.location ?? "--//--"
    
    createdLabel.text  = changeDateFormatt(date: viewModel.createdAt)

    
  }
  
  

}
