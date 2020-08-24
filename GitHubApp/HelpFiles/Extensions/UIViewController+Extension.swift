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
    
    let alertControlelr = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    alertControlelr.addAction(alertAction)
    present(alertControlelr, animated: true, completion: nil)
  }

  
  
  
}

