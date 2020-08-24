//
//  AppDelegate.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window : UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    initServiceLocator()
    root()
    
    return true
  }
  
  private func root() {
    window = UIWindow(frame: UIScreen.main.bounds)
    let navController = UINavigationController(rootViewController: MainViewController())
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
  }
  
  private func initServiceLocator() {
    
    let locator = ServiceLocator.shared
    locator.addService(service: GitHubApi.shared)
  }



}

