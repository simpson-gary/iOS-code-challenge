//
//  BaseScrollableViewController.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

class BaseScrollableViewController: UIViewController {
  
  //MARK: Init UI Elements
  let scrollContentView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    
    scrollView.isScrollEnabled = true
    scrollView.showsVerticalScrollIndicator = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.alwaysBounceVertical = true
    scrollView.backgroundColor = .clear
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(scrollView)
    scrollView.addSubview(scrollContentView)
    
    setScrollLayout()
  }
  
  
  // MARK: - Navigation
  func setAppBarProperties() {
    let backItem = UIBarButtonItem()
    backItem.tintColor = UIColor.white
    backItem.title = " "
    let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    navigationController?.setNavigationBarHidden(false, animated: false)
    navigationController?.navigationBar.isOpaque = true
    navigationController?.navigationBar.barTintColor = UIColor.white
    navigationController?.navigationBar.titleTextAttributes = textAttributes
  }
  
  
  //MARK: - Layout Constraints
  func setScrollLayout() {
    scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    
    scrollContentView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, padding: UIEdgeInsets.zero)
    scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
  }
}
