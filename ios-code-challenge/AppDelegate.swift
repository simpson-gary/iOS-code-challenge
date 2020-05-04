//
//  AppDelegate.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
//  Copyright © 2020 Gary Simpson. All rights reserved.
//


import UIKit
import MapKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    //Format with '%20' for spaces

    window?.rootViewController = Navigation.getSplitViewController()
    window?.makeKeyAndVisible()
    return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
      print("applicationDidEnterBackground")
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
      print("applicationWillEnterForeground")
  }
 
  // MARK: - Split view
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {

      //Force app to start at masterView.
      return true
  }
}
