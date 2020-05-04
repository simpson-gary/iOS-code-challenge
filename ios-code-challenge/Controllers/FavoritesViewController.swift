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
    
    queryForFavorites()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.tabBarController?.navigationItem.titleView = titleLabel
    FavoritesViewController.favoritesList = FavoritesViewController.loadFavoritesList()
  }
  
  func updateFavoritesList() {
    
  }
  
//  //MARK: - SearchQuery
//  func executeSearch(query: YLPSearchQuery, page: Bool = false) {
//    query.limit = 5
//
//
//    AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
//      guard let strongSelf = self,
//        let dataSource = strongSelf.dataSource,
//        let businesses = searchResult?.businesses else {
//          return
//      }
//
//      dataSource.appendObjects(businesses)
//      dataSource.setDetailView(self)
//
//      strongSelf.tableView.reloadData()
//    })
//  }
  
  func queryForFavorites() {
    //let fav = "sanford"
    FavoritesViewController.favoritesList.forEach { fav in
      let query = YLPSearchQuery(location: fav)
      query.limit = 5
    
      executeSearch(query: query)
    }
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
  
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



