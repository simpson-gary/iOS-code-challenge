//
//  BaseBackgroundStackView.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

/**
 Provides a base UIStackView with rounded corners & UIView with background blurr effect applied.
 
 - Important:
 Defaults isHidden = true.
 */
class BaseBackgroundStackView: UIStackView {
  let margin: CGFloat = 8
  
  var backgroundView: UIView = {
    let view = UIView()
    //view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
    view.layer.cornerRadius = 8.0
    view.layer.borderWidth = 2.0
    if #available(iOS 13.0, *) {
      view.layer.borderColor = UIColor.systemFill.cgColor
    } else {
      // Fallback on earlier versions
      view.layer.borderColor = UIColor.lightGray.cgColor
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    spacing = 4.0
    layoutMargins = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
    
    //clipsToBounds = true
    isLayoutMarginsRelativeArrangement = true
    alignment = .leading
    distribution = UIStackView.Distribution.fill
    axis = .vertical
    
    isHidden = true
    setupBackgroundView()
    setupBlurEffect()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupBlurEffect() {
    var blurEffect: UIBlurEffect
    
    if #available(iOS 13.0, *) {
      blurEffect = UIBlurEffect(style: .systemThickMaterial)
    } else {
      blurEffect = UIBlurEffect(style: .dark)
    }
    
    let visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    backgroundView.addSubview(visualEffectView)
    visualEffectView.anchorToFillSuperView()
    visualEffectView.alpha = 0.75
  }
  
  func setupBackgroundView() {
    insertSubview(backgroundView, at: 0)
    backgroundView.anchorToFillSuperView()
    backgroundView.clipsToBounds = true
  }
}
