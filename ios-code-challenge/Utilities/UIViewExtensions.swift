//
//  UIViewExtensions.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/2/20.
//  Copyright © 2020 Gary Simpson. All rights reserved.
//

import UIKit

var vSpinner : UIView?

extension UIViewController {
  func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
  }
  
  func removeSpinner() {
    DispatchQueue.main.async {
      vSpinner?.removeFromSuperview()
      vSpinner = nil
    }
  }
}

extension UIView {
  func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
    var topInset = CGFloat(0)
    var bottomInset = CGFloat(0)
    
    if #available(iOS 11, *), enableInsets {
      let insets = self.safeAreaInsets
      topInset = insets.top
      bottomInset = insets.bottom
    }
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
    }
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
    }
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
  }
  
  /**
   Sets view anchors based on provided NSLayoutYAxisAnchor & NSLayoutXAxisAnchor items. Also allows for setting of padding & size constraints.
                                                   
   - Important:
   padding & size parameters default to '.zero'.
                                                   
   - Parameters:
   - top: NSLayoutYAxisAnchor object.
   - leading: NSLayoutXAxisAnchor object.
   - bottom: NSLayoutYAxisAnchor object.
   - trailing: NSLayoutXAxisAnchor object.
   - padding: UIEdgeInsets object.
   - size: CGSize object.
   */
  func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
    }
    
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
    }
    
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
    }
    
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
  }
  
  /**
   Set the views anchor to equal that of its superview. Set "safe" true if safeAreaLayout needed.
   */
  func anchorToFillSuperView(safe: Bool = false) {
    if safe {
      anchor(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.safeAreaLayoutGuide.leadingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, trailing: superview?.safeAreaLayoutGuide.trailingAnchor)
    } else {
      anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
  }
  
}
