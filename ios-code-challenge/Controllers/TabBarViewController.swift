//
//  TabBarViewController.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
  var detailViewController = DetailViewController()
  let firstViewController = MasterViewController()
  let secondViewController = FavoritesViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstViewController.detailViewController = detailViewController
    firstViewController.tabViewController = self
    firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    
    secondViewController.detailViewController = detailViewController
    secondViewController.tabViewController = self
    secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    
    let tabBarList = [firstViewController, secondViewController]
    
    viewControllers = tabBarList
  }
  
  
  @objc func executePageQuery() {
    switch self.selectedIndex {
    case 0:
      firstViewController.executePageQuery()
      break;
    case 1:
      debugPrint("TabBarViewController:: secondViewController! #\(self.selectedIndex).")
      secondViewController.executePageQuery()
      break;
    default:
      debugPrint("TabBarViewController:: ERROR! #\(self.selectedIndex) Unaccounted for in switch.")
    }
  }
  
  // MARK: - Navigation
  @objc func transitionDetailView(cell: NXTBusinessTableViewCell) {
    //debugPrint("TabBarViewController:: transitionDetailView: business = #\(cell.business?.name ?? "") tapped.")
    
    detailViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    detailViewController.navigationItem.leftItemsSupplementBackButton = true
    
    detailViewController.business = cell.business
    let image = cell.businessImage.image?.cgImage?.copy()
    detailViewController.imageView!.image = UIImage.init(cgImage: image!)
    
    //Show detailView for portriat iPhone
    if splitViewController?.isCollapsed ?? false {
      let detailNavController = detailViewController.navigationController
      splitViewController?.showDetailViewController(detailNavController!, sender: self)
    }
  }
}
