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
    iv.clipsToBounds = true
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
    //bottomVStack
    let stack = UIStackView(arrangedSubviews: [
      topHStack,
      bottomVStack
    ])
    stack.axis         = .vertical
    stack.distribution = .fill
    stack.alignment    = .fill
    stack.spacing      = 10
    
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private lazy var topHStack: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [avatarImageView,rightVStack])
    hStack.axis         = .horizontal
    hStack.distribution = .fill
    hStack.spacing      = 5
    hStack.alignment    = .top
    hStack.translatesAutoresizingMaskIntoConstraints = false
    return hStack
  }()
  
  
  private lazy var rightVStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameHStack,loginHStack])
    stack.axis         = .vertical
    stack.distribution = .fill
    stack.alignment    = .fill
    stack.spacing      = 10
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  private lazy var bottomVStack: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [locationHStack,createdHStack])
    hStack.axis         = .vertical
    hStack.distribution = .fillEqually
    hStack.spacing       = 5
    hStack.translatesAutoresizingMaskIntoConstraints = false
    return hStack
  }()
  
  private lazy var nameHStack : UIStackView = {
    
//    let vStack = UIStackView(arrangedSubviews: [nameLabel])
//    vStack.distribution = .fill
//    vStack.alignment    = .fill
//    vStack.axis         = .vertical
    nameLabel.numberOfLines = 0
    nameLabel.lineBreakMode = .byWordWrapping
    
    let stackView = UIStackView(arrangedSubviews: [nameTitleLabel,nameLabel])
    stackView.alignment = .top
    stackView.axis      = .horizontal
    stackView.alignment = .firstBaseline
    stackView.spacing   = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var locationHStack : UIStackView = {
    
//    let vStack = UIStackView(arrangedSubviews: [locationLabel])
//    vStack.distribution = .fill
//    vStack.alignment    = .fill
//    vStack.axis         = .vertical
    locationLabel.numberOfLines = 0
    locationLabel.lineBreakMode = .byCharWrapping
    
    let stackView = UIStackView(arrangedSubviews: [locationTitleLabel,locationLabel])
    stackView.axis      = .horizontal
    stackView.alignment = .firstBaseline
    stackView.spacing   = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var createdHStack : UIStackView = {
     
//     let vStack = UIStackView(arrangedSubviews: [createdLabel])
//     vStack.distribution = .fill
//     vStack.alignment    = .fill
//     vStack.axis         = .vertical
     createdLabel.numberOfLines = 0
     createdLabel.lineBreakMode = .byCharWrapping
     
     let stackView = UIStackView(arrangedSubviews: [createdTitleLabel,createdLabel])
     stackView.axis      = .horizontal
     stackView.alignment = .firstBaseline
     stackView.spacing   = 5
     stackView.translatesAutoresizingMaskIntoConstraints = false
     return stackView
   }()
  
  private lazy var loginHStack = createSimpleHStack(view1: loginTitleLabel, view2: loginLabel,aligment: .firstBaseline)
  
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor(named: "HeaderBackround")
    
    addSubViews()
    
    setPriorites()
  }
  
  private func setPriorites() {
    //  Title зафиксирвоали свой размер и больше не сжимаются и не растутт
  
    [nameTitleLabel,loginTitleLabel,locationTitleLabel,createdTitleLabel].forEach{
      
      $0.setContentHuggingPriority(.required, for: .horizontal)
      $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // Имя должно занять все место какое есть если что
    nameLabel.setContentHuggingPriority(.required, for: .vertical)
    nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func addSubViews() {
    addSubview(stack)
    stack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    avatarImageView.constrainWidth(constant: height * 0.5)
    avatarImageView.constrainHeight(constant: height * 0.5)

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}



// MARK: - set ViewModel
extension DetailHeaderView {
  
  func configure(viewModel:DetailHeaderViewable) {
    
    if let image = imageCache.getImage(key: viewModel.avatarUrl.absoluteString) {
      avatarImageView.image = image
    }
    
    nameLabel.text     = viewModel.name     ?? "--//--"
    loginLabel.text    = viewModel.login
    locationLabel.text = viewModel.location ?? "--//--"
    
    createdLabel.text  = changeDateFormatt(date: viewModel.createdAt)
    
    
    
  }
  
  
  
  
  
  
  
}




