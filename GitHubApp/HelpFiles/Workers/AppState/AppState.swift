//
//  AppState.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 17.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit



// Класс который отвечает за отображение OnBoarding - Когда эта задача будет выполнена мы просто сними Onboarding с UIWindow и все!

final class AppState {
  
  
  static var shared = AppState()
  
  var mainWindow    = UIWindow(frame: UIScreen.main.bounds)
  
  lazy var loadingActivityIndicator = LoadingActivityIndicator(frame:.zero)
  
  
  private init () {}
  

}

// MARK: - Set Loading Activity Indicator
extension AppState {
  func setLoadingActivityIndicator() {
    
    mainWindow.addSubview(loadingActivityIndicator)
    loadingActivityIndicator.centerInSuperview(size: .init(width: 150, height: 100))
    
    loadingActivityIndicator.isHidden = true
  }
  
  func showLoadingActivitIndicator() {
    loadingActivityIndicator.activityIndicator.startAnimating()
    loadingActivityIndicator.isHidden = false
  }
  

  

  
  func dismisLoadingActivtiIndiactor() {
    
    self.loadingActivityIndicator.activityIndicator.stopAnimating()
    self.loadingActivityIndicator.isHidden = true
  }
}


