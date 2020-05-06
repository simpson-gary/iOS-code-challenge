//
//  FavoritesViewController.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseTableViewController<Any, NXTBusinessTableViewCell> {
  static let favoritesKey = "iosCodeChallenge.favorites"
  static var favoritesList = [String]()
  
  private let titleLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .title2)
    lbl.text = "Favorites"
    lbl.textAlignment = .center
    return lbl
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    FavoritesViewController.favoritesList = FavoritesViewController.loadFavoritesList()
    queryForFavorites()
    //updateDataSource(Favorites.global.compactMap({$0.business}))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.tabBarController?.navigationItem.titleView = titleLabel
    
  }
  
  
  func queryForFavorites() {
    //let fav = "sanford"
    FavoritesViewController.favoritesList.forEach { fav in
      //let query = YLPSearchQuery(location: fav)
      //query.limit = 5
      
      //executeSearch(query: query)
      
      fetchYelpBusinessDetails(withID: fav)
    }
  }
  
  fileprivate func fetchYelpBusinessDetails(withID  id: String, using session: URLSession = .shared) {
    session.request(.details(withID: id)) {
      data, response, error in
      guard error == nil else {
        debugPrint(error!)
        return
      }
      guard let data = data else { return }
      
      do {
        let details = try JSONDecoder().decode(YLPBusinessDetails.self, from: data)
        ///Update details var object
        debugPrint(" ========================\n \(data)")
        let business = details.toYLPBusiness()
        
        DispatchQueue.main.async {
          self.updateDataSource([business])
        }
      } catch let jsonError {
        debugPrint(jsonError)
      }
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

