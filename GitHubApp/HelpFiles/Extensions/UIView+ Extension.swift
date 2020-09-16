//
//  UIView+Extensions.swift
//  BSL(MVVM)
//
//  Created by PavelM on 22/07/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

//
//  UIView+Layout.swift


import UIKit

// MARK: Anchor
extension UIView {
  
  @discardableResult
  func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
    
    translatesAutoresizingMaskIntoConstraints = false
    var anchoredConstraints = AnchoredConstraints()
    
    if let top = top {
      anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
    }
    
    if let leading = leading {
      anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
    }
    
    if let bottom = bottom {
      anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
    }
    
    if let trailing = trailing {
      anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
    }
    
    if size.width != 0 {
      anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
    }
    
    if size.height != 0 {
      anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
    }
    

    
    [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
    
    return anchoredConstraints
  }
  
  func fillSuperview(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    if let superviewTopAnchor = superview?.topAnchor {
      topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
    }
    
    if let superviewBottomAnchor = superview?.bottomAnchor {
      bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
    }
    
    if let superviewLeadingAnchor = superview?.leadingAnchor {
      leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
    }
    
    if let superviewTrailingAnchor = superview?.trailingAnchor {
      trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
    }
  }
  
  func centerInSuperview(size: CGSize = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    if let superviewCenterXAnchor = superview?.centerXAnchor {
      centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
    }
    
    if let superviewCenterYAnchor = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
    }
    
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
  }
  
  func centerXInSuperview() {
    translatesAutoresizingMaskIntoConstraints = false
    if let superViewCenterXAnchor = superview?.centerXAnchor {
      centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
    }
  }
  
  func centerYInSuperview() {
    translatesAutoresizingMaskIntoConstraints = false
    if let centerY = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
  }
  
  func constrainWidth(constant: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: constant).isActive = true
  }
  
  func constrainHeight(constant: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: constant).isActive = true
  }
}

struct AnchoredConstraints {
  var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}


// MARK: - Stack
extension UIView {
  func createSimpleHStack(view1: UIView,view2: UIView,aligment:UIStackView.Alignment = .fill) -> UIStackView {
    let hStack = UIStackView(arrangedSubviews: [view1,view2])
    hStack.distribution  = .fill
    hStack.axis          = .horizontal
    hStack.spacing       = 5
    hStack.alignment     = aligment
    return hStack
  }
  
  func createSimpleVStack(view1: UIView,view2: UIView) -> UIStackView {
    let vStack = UIStackView(arrangedSubviews: [view1,view2])
    vStack.distribution  = .fillEqually
    vStack.axis          = .vertical
    vStack.spacing       = 5
    return vStack
  }
  
  func createSimpleLabel(font: UIFont,text:String? = nil) -> UILabel {
    let l = UILabel()
    l.font          = font
    l.text          = text
    l.textAlignment = .left
    l.sizeToFit()
    l.translatesAutoresizingMaskIntoConstraints = false
    return l
  }
  
  func changeDateFormatt(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
    var currentString = ""
    
    if let date = dateFormatter.date(from: date) {
      dateFormatter.dateFormat = "dd-MM-yyyy"
      currentString = dateFormatter.string(from: date)
      
    }
    return currentString
  }
  
  func changeDateFormattWithTime(date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
    var currentString = ""
    
    if let date = dateFormatter.date(from: date) {
      dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
      currentString = dateFormatter.string(from: date)
      
    }
    return currentString
  }
}

// MARK: Frame
extension UIView {
  
  var width : CGFloat {
    frame.size.width
  }
  
  var height : CGFloat {
    frame.size.height
  }
  var top : CGFloat {
    frame.origin.y
  }
  var bottom : CGFloat {
    frame.origin.y + frame.size.height
  }
  
  var left : CGFloat {
    frame.origin.x
  }
  var right : CGFloat {
    frame.origin.x + frame.size.width
  }
}

