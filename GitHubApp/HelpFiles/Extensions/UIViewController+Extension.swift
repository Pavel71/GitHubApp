//
//  UIViewController+Extension.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


extension UIViewController {
  
  
  func showAlert(title: String = "Что-то пошло не так", message: String) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    alertController.addAction(alertAction)
    alertController.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
    present(alertController, animated: true, completion: nil)
  }

  
  
  
}

