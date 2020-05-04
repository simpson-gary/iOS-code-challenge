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
    
    updateDataSource(Favorites.global.compactMap({$0.business}))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.tabBarController?.navigationItem.titleView = titleLabel
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
          ///Update details var object
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

