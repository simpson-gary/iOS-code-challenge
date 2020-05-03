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




class Navigation: NSObject {

  class func switchToNewRootController() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    appDelegate.window?.rootViewController = getSplitViewController()
    appDelegate.window?.makeKeyAndVisible()
  }
  
//   class func getRootViewController() -> UIViewController {
//       let previouslyLaunched = ArchiveUtil.loadFirstLaunchBool()
//     var rootView: UIViewController
//
//       switch previouslyLaunched {
//       case true:
//         rootView =  getSplitViewController()
//       case false:
//         rootView =  getOnBoardingView()
//       }
//
//     return rootView
//   }
     
//   class func getOnBoardingView() -> UIViewController {
//     let viewController = OnBoardingViewController()
//     return viewController
//   }
//
   class func getSplitViewController() -> UISplitViewController {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
//       let locations: [CLLocationCoordinate2D] = {
//        let list = ArchiveUtil.loadLocations()!
//        return list
//       }()
       
       let masterViewController: MasterViewController = MasterViewController()
       
      let detailViewController = DetailViewController()
      masterViewController.detailViewController = detailViewController

      let masterNavigationController = UINavigationController(rootViewController: masterViewController)
      let detailNavigationController = UINavigationController(rootViewController: detailViewController)

      let splitViewController =  UISplitViewController()
      splitViewController.viewControllers = [masterNavigationController,detailNavigationController]
      splitViewController.preferredDisplayMode = .allVisible
      splitViewController.delegate = appDelegate
     
     return splitViewController
  }
}
