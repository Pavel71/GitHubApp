//
//  LoadingActivityIndicator.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit


class LoadingActivityIndicator : UIView {
  
  var activityIndicator : UIActivityIndicatorView = {
    let av = UIActivityIndicatorView(style: .white)
    return av
  }()
  
  var loadingLabel: UILabel = {
    let label = UILabel()
    label.font          = UIFont.systemFont(ofSize: 18, weight: .heavy)
    label.textColor     = .white
    label.text          = "Loading..."
    label.textAlignment = .center
    return label
  }()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setViews()
    
    backgroundColor    = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    clipsToBounds      = true
    layer.cornerRadius = 15
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Set Views
extension LoadingActivityIndicator {
  private func setViews() {
    let vStack = UIStackView(arrangedSubviews: [loadingLabel,activityIndicator])
    vStack.distribution = .fillEqually
    vStack.spacing      = 5
    vStack.axis         = .vertical
    
    addSubview(vStack)
    vStack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
}
