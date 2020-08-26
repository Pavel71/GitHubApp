//
//  RepoListCell.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


protocol RepoListCellable {
  var name            : String  {get set}
  var language        : String? {get set}
  var isNeedMoreInfo  : Bool    {get set}
  var updatedAt       : String  {get set}
  var stars           : Int     {get set}

}

class RepoListCell : UITableViewCell {
   
  static let cellId = "RepoListCell"
  
  // MARK: - Views
  
  
  private lazy var  repoTitleLabel = createSimpleLabel(font: UIFont.systemFont(ofSize: 20), text: "Name:")
   private lazy var repoLabel      = createSimpleLabel(font: UIFont.systemFont(ofSize: 18))
  
  private lazy var languageTitleLabel = createSimpleLabel(font: UIFont.systemFont(ofSize: 20), text: "Language:")
  private lazy var languageLabel      = createSimpleLabel(font: UIFont.systemFont(ofSize: 18))
  
  private lazy var updateDateTitleLabel = createSimpleLabel(font: UIFont.systemFont(ofSize: 20), text: "Last update:")
  private lazy var updateDateLabel      = createSimpleLabel(font: UIFont.systemFont(ofSize: 18))
  
  private lazy var starsTitleLabel = createSimpleLabel(font: UIFont.systemFont(ofSize: 20), text: "Stars:")
  private lazy var starLabel      = createSimpleLabel(font: UIFont.systemFont(ofSize: 18))
  
  private lazy var moreDataButton : UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("More Info", for: .normal)
    b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    return b
  }()
  
  //MARK: - StacksView
  
  private lazy var stack : UIStackView = {
    let stack = UIStackView(arrangedSubviews: [languageHStack,
                                               repoHStack,
                                               moreDataButton,
                                               lastUpdateHStack,
                                               starsHStack])
    stack.distribution = .equalSpacing
    stack.axis         = .vertical
    stack.spacing      = 5
    return stack
  }()
  
  
  private lazy var repoHStack : UIStackView = {
    let vStack = UIStackView(arrangedSubviews: [repoLabel])
       vStack.distribution = .fill
       vStack.alignment    = .fill
       vStack.axis         = .vertical
       repoLabel.numberOfLines = 0
       
       let stackView = UIStackView(arrangedSubviews: [repoTitleLabel,vStack])
       stackView.alignment = .fill
       stackView.axis      = .horizontal
    return stackView
  }()
  
  private lazy var languageHStack = createSimpleHStack(view1: languageTitleLabel, view2: languageLabel)
//  private lazy var repoStack     = createSimpleHStack(view1: repoTitleLabel, view2: repoLabel)
  private lazy var lastUpdateHStack = createSimpleHStack(view1: updateDateTitleLabel, view2: updateDateLabel)
  private lazy var starsHStack      = createSimpleHStack(view1: starsTitleLabel, view2: starLabel)
  
  // MARK: Clousers
  
  var didTapMoreButtonClouser : ((UIButton) -> Void)?
  
    // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    [repoLabel,languageLabel,starLabel,updateDateLabel].forEach{
      $0.textAlignment = .right  
    }
    
    moreDataButton.addTarget(self, action: #selector(handleMoreDataInfo), for: .touchUpInside)
    
    setViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Set Views
extension RepoListCell {
  func setViews() {
    addSubview(stack)
    stack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    [repoTitleLabel,starsTitleLabel,languageTitleLabel,updateDateTitleLabel].forEach{
      $0.constrainWidth(constant: 120)
    }
  }
}

// MARK: Set ViewModel
extension RepoListCell {
  
  
  func configure(viewModel:RepoListCellable) {
    self.repoLabel.text       = viewModel.name
    self.languageLabel.text   = viewModel.language ?? "--//--"
    
    
    
    if viewModel.isNeedMoreInfo {
      self.starLabel.text       = "\(viewModel.stars)"
      self.updateDateLabel.text = changeDateFormattWithTime(date: viewModel.updatedAt)
      
      self.starsHStack.isHidden      = false
      self.lastUpdateHStack.isHidden = false
    } else {
      self.starsHStack.isHidden      = true
      self.lastUpdateHStack.isHidden = true
    }
    
  }
  
  
}
// MARK: Signals

extension RepoListCell {
  
  @objc private func handleMoreDataInfo(button: UIButton) {
    didTapMoreButtonClouser!(button)
  }
}
