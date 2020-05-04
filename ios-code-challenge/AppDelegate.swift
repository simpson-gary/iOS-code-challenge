//
//  AppDelegate.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
//  Copyright © 2020 Gary Simpson. All rights reserved.
//


import UIKit
import CoreData
import MapKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

var window: UIWindow?
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Favorites")
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    //Format with '%20' for spaces

    window?.rootViewController = Navigation.getSplitViewController()
    window?.makeKeyAndVisible()
    
    
    // getFavorites on different thread for performance
    let priority = DispatchQoS.QoSClass.default
    DispatchQueue.global(qos: priority).async {
        // do some task
      FavoritesHandler().getFavorites()
        DispatchQueue.main.async {
            // update some UI
        }
    }
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
  
  // MARK: - Core Data stack

  lazy var applicationDocumentsDirectory: URL = {
      // The directory the application uses to store the Core Data store file. This code uses a directory named "GarySimpson" in the application's documents Application Support directory.
      let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return urls[urls.count-1]
  }()

  lazy var managedObjectModel: NSManagedObjectModel = {
      // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
      let modelURL = Bundle.main.url(forResource: "iOSCodeChallenge", withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
      // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
      // Create the coordinator and store
      let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
      var failureReason = "There was an error creating or loading the application's saved data."
      do {
          try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
      } catch {
          // Report any error we got.
          var dict = [String: AnyObject]()
          dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
          dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

          dict[NSUnderlyingErrorKey] = error as NSError
          let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
          // Replace this with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
          abort()
      }
      
      return coordinator
  }()

  lazy var managedObjectContext: NSManagedObjectContext = {
      // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
      let coordinator = self.persistentStoreCoordinator
      var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      managedObjectContext.persistentStoreCoordinator = coordinator
      return managedObjectContext
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      if managedObjectContext.hasChanges {
          do {
              try managedObjectContext.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
              abort()
          }
      }
  }
}
