//
//  NavigationUtility.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import Foundation

class Navigation: NSObject {
  
  class func switchToNewRootController() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    appDelegate.window?.rootViewController = getSplitViewController()
    appDelegate.window?.makeKeyAndVisible()
  }
  
  class func getSplitViewController() -> UISplitViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let masterViewController: TabBarViewController = TabBarViewController()
    
    let detailViewController = masterViewController.detailViewController
    
    let masterNavigationController = UINavigationController(rootViewController: masterViewController)
    let detailNavigationController = UINavigationController(rootViewController: detailViewController)
    
    let splitViewController =  UISplitViewController()
    splitViewController.viewControllers = [masterNavigationController,detailNavigationController]
    splitViewController.preferredDisplayMode = .allVisible
    splitViewController.delegate = appDelegate
    
    return splitViewController
  }
}
