//
//  FavoritesViewController.swift
//  ios-code-challenge
//
//  Created by Jinglz on 5/3/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseTableViewController<Any, NXTBusinessTableViewCell> {
  static let favoritesKey = "iosCodeChallenge.favorites"
  static var favoritesList = [String]()
//  var businessDetails: [YLPBusinessDetails]? {
//    didSet {
//      debugPrint("FavoritesView:: businessDetails: didSet.")
//      if  businessDetails?.count ?? 0 != 0 && businessDetails?.count == FavoritesViewController.favoritesList.count {
//        var businessList = [YLPBusiness]()
//        businessDetails!.forEach { detail in
//          //let detail = businessDetails.last
//
//          let biz = YLPBusiness.init(variables: detail.name? ?? "",
//                                     detail.image_url! ?? "",
//                                     detail.price ?? "",
//                                     detail.rating! as! NSNumber,
//                                     detail.id ?? "",
//                                     detail.review_count as! NSNumber)
//
//          debugPrint("FavoritesView:: setDetails: \(detail.name ?? "").")
//          businessList.append(biz)
//        }
//        DispatchQueue.main.async {
//          self.updateDataSource(businessList)
//        }
//      }
//    }
//  }
  
  //  lazy private var dataSource: NXTDataSource? = {
  //    guard let dataSource = NXTDataSource(objects: nil) else { return nil }
  //    dataSource.tableViewDidReceiveData = { [weak self] in
  //      guard let strongSelf = self else { return }
  //      strongSelf.tableView.reloadData()
  //    }
  //    return dataSource
  //  }()
  
  private let titleLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .title2)
    lbl.text = "Favorites"
    lbl.textAlignment = .center
    return lbl
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    tableView.dataSource = dataSource
    //    tableView.delegate = dataSource
    //    tableView.allowsSelection = true
    //businessDetails = [YLPBusinessDetails]()
    updateDataSource(Favorites.global.compactMap({$0.business}))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.tabBarController?.navigationItem.titleView = titleLabel
    //FavoritesViewController.favoritesList = FavoritesViewController.loadFavoritesList()
    //queryForFavorites()
  }
  
  
  func queryForFavorites() {
    //let fav = "sanford"
    FavoritesViewController.favoritesList.forEach { fav in
      //let query = YLPSearchQuery(location: fav)
      //query.limit = 5
      
      //executeSearch(query: query)
      
      fetchYelpBusinesses()
    }
  }
  
  fileprivate func fetchYelpBusinesses() {
    FavoritesViewController.favoritesList.forEach{ id in
      print("FavoritesView:: fetching details for ID=\(id)")
      
      let url = URL(string: "\(Strings.baseUrl)businesses/\(id)")
      var request = URLRequest(url: url!)
      request.setValue("Bearer \(Strings.apiKey)", forHTTPHeaderField: "Authorization")
      request.httpMethod = "GET"
      
      URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
          debugPrint(error!)
          return
        }
        
        guard let data = data else { return }
        
        do {
          let details = try JSONDecoder().decode(YLPBusinessDetails.self, from: data)
          
          debugPrint("FavoritesView:: fetchYelpBusinesses: \(details.name ?? "").")
          //self.businessDetails?.append(details)
        } catch let jsonError {
          debugPrint(jsonError)
        }
      }.resume()
    }
  }
  
  //MARK: - Favorites
  static func loadFavoritesList() -> [String] {
    guard let favorites = UserDefaults.standard.array(forKey: favoritesKey) as? [String] else {
      return [String]()
    }
    
    return favorites
  }
  
  static func saveFavoritesList(list: [String]) {
    UserDefaults.standard.set(list, forKey: favoritesKey)
  }
}





class Favorite : NSObject , NSCoding {
  // MARK: Properties
  var business: YLPBusiness?
  
  // MARK: Archiving Paths
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Favorites")
  
  // MARK: Initialization
  init?(business: YLPBusiness?) {
    // Initialize stored properties
    self.business = business
    
    // Must call initilizer before returning nil.
    super.init()
  }
  
  // MARK: Types
  struct PropertyKey {
    static let businessKey = "business"
  }
  
  // MARK: NSCoding
  func encode(with aCoder: NSCoder) {
    aCoder.encode(business, forKey: PropertyKey.businessKey)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let business = aDecoder.decodeObject(forKey: PropertyKey.businessKey) as? YLPBusiness
    
    // Must call designated initilizer.
    self.init(business: business)
  }
  
}


import Foundation
//struct to hold VisualizationImages
struct Favorites {
    static var global = [Favorite]()
}

class FavoritesHandler: NSObject {

    var favorites = [Favorite]()
    
    func setFavorites(_ faves : [Favorite]) {
        favorites = faves
        
        // saveFavorites on different thread for performance
        let priority = DispatchQoS.QoSClass.default
        DispatchQueue.global(qos: priority).async {
            // do some task
            self.saveFavorites()
            self.getFavorites()
            DispatchQueue.main.async {
                // update some UI
            }
        }
    }
    
    func getFavorites() {
        if (loadFavorites() != nil && loadFavorites()?.count != 0) {
            print("Favorites found on device  " + String(describing: loadFavorites()?.count) )
            let loadedVFavorites = loadFavorites()
            favorites = loadedVFavorites!
            Favorites.global = favorites
        } else {
            favorites = [Favorite]()
            Favorites.global = favorites
        }
    }
    
    // MARK: NSCoding
   private func saveFavorites() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favorites, toFile: Favorite.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save visualizationImages...")
        } else {
            print("Saved :-) visualizationImages...")
        }
    }
    
    private func loadFavorites() -> [Favorite]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Favorite.ArchiveURL.path) as? [Favorite]
    }
    
}

