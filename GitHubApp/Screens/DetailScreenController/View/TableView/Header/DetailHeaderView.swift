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
  
  // MARK: Workers
  
  let imageCache : ImageCachWorker! = ServiceLocator.shared.getService()
  
  // MARK: - Views
  
  private var avatarImageView: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .lightGray
    iv.contentMode     = .scaleAspectFit
    iv.translatesAutoresizingMaskIntoConstraints = false
//    iv.clipsToBounds = true
//    iv.layer.cornerRadius = 15
    return iv
  }()
  // Name
  private lazy var nameTitleLabel    = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Name:")
  private lazy var nameLabel         = createSimpleLabel(font: .systemFont(ofSize: 18))
  
    // Login
  private lazy var loginTitleLabel       = createSimpleLabel(font: .systemFont(ofSize: 20),text:"Login:")
  private lazy var loginLabel            = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  // Created at
  private lazy var createdTitleLabel     = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Created:")
  private lazy var createdLabel: UILabel = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  // Location
  private lazy var locationTitleLabel     = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Location:")
  private lazy var locationLabel: UILabel = createSimpleLabel(font: .systemFont(ofSize: 18))
  

  
  // MARK: - Stacks
  
  private lazy var stack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [topHStack,bottomVStack])
        stack.axis         = .vertical
        stack.distribution = .fill
        stack.spacing      = 10
    
    stack.translatesAutoresizingMaskIntoConstraints = false
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
    let stack = UIStackView(arrangedSubviews: [nameHStack,loginHStack])
        stack.axis         = .vertical
        stack.distribution = .fillEqually
        stack.spacing      = 5
        stack.alignment    = .leading
    return stack
  }()
  private lazy var bottomVStack: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [locationHStack,createdHStack])
        hStack.axis         = .vertical
        hStack.distribution = .fillEqually
        hStack.spacing       = 5
    return hStack
  }()
  
  private lazy var nameHStack : UIStackView = {
    
    let vStack = UIStackView(arrangedSubviews: [nameLabel])
    vStack.distribution = .fill
    vStack.alignment    = .fill
    vStack.axis         = .vertical
    nameLabel.numberOfLines = 0
    
    let stackView = UIStackView(arrangedSubviews: [nameTitleLabel,vStack])
    stackView.alignment = .fill
    stackView.axis      = .horizontal
    
    return stackView
  }()
  
  private lazy var locationHStack = createSimpleHStack(view1: locationTitleLabel, view2: locationLabel)
  private lazy var createdHStack  = createSimpleHStack(view1: createdTitleLabel, view2: createdLabel)

  private lazy var loginHStack    = createSimpleHStack(view1: loginTitleLabel, view2: loginLabel)
  
  
  
  // MARK: Constraints
  
  private var staticConstraints :[NSLayoutConstraint] {
    [
      stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
      avatarImageView.widthAnchor.constraint(equalToConstant: 100),
      avatarImageView.heightAnchor.constraint(equalToConstant: 100),
      locationTitleLabel.widthAnchor.constraint(equalToConstant: 100),
      createdTitleLabel.widthAnchor.constraint(equalToConstant: 100),
      nameTitleLabel.widthAnchor.constraint(equalToConstant: 60),
      loginTitleLabel.widthAnchor.constraint(equalToConstant: 60)
    ]
  }

  
  
    // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor(named: "HeaderBackround")
    setViews()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    
    NSLayoutConstraint.activate(
    staticConstraints
    )
    
    
    super.updateConstraints()
  }
  
}

// MARK: - Set Views
extension DetailHeaderView {
  
  func setViews() {
    
    addSubview(stack)
//    stack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
//
//    avatarImageView.constrainWidth(constant: 100)
//    avatarImageView.constrainHeight(constant: 100)
//
//
//    [locationTitleLabel,createdTitleLabel] .forEach { (label) in
//      label.constrainWidth(constant: 100)
//    }
//
//    [nameTitleLabel,loginTitleLabel] .forEach { (label) in
//      label.constrainWidth(constant: 60)
//    }
    

  }
  
}


// MARK: - set ViewModel
extension DetailHeaderView {
  
  func configure(viewModel:DetailHeaderViewable) {
    
    avatarImageView.image = imageCache.getImage(key: viewModel.avatarUrl.absoluteString)
    
    nameLabel.text     = viewModel.name     ?? "--//--"
    loginLabel.text    = viewModel.login
    locationLabel.text = viewModel.location ?? "--//--"
    
    createdLabel.text  = changeDateFormatt(date: viewModel.createdAt)

    setNeedsUpdateConstraints()
  }
  
  
  

}
