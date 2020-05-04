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
  var businessDetails: [YLPBusinessDetails]? {
    didSet {
      debugPrint("FavoritesView:: businessDetails: didSet.")
      if businessDetails?.count ?? 0 > 0 && businessDetails?.count == FavoritesViewController.favoritesList.count {
        var businessList = [YLPBusiness]()
        businessDetails!.forEach { detail in
          //let detail = businessDetails.last
            
          let biz = YLPBusiness.init(variables: detail.name! ,
                                     detail.image_url! ?? "",
                                     detail.price ?? "",
                                     detail.rating! as! NSNumber,
                                     detail.id ?? "",
                                     detail.review_count as! NSNumber)
          
            debugPrint("FavoritesView:: setDetails: \(detail.name ?? "").")
            businessList.append(biz)
        }
        updateDataSource(businessList)
      }
    }
  }
  
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
    businessDetails = [YLPBusinessDetails]()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.tabBarController?.navigationItem.titleView = titleLabel
    FavoritesViewController.favoritesList = FavoritesViewController.loadFavoritesList()
    queryForFavorites()
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

    var tempBusinessDetailsList = [YLPBusinessDetails]()
    
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
            self.businessDetails?.append(details)
          } catch let jsonError {
            debugPrint(jsonError)
          }
          }.resume()
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

struct Location: Decodable {
  let latitude: Float?
  let longitude: Float?
}

struct DailyHours: Decodable {
  let is_overnight: Bool?
  let start: String?
  let end: String?
  let day: Int?
}


struct Categories: Decodable {
  let alias: String?
  let title: String?
}

struct Hours: Decodable {
  let open: [DailyHours]?
  let hours_type: String?
  let is_open_now: Bool?
}

struct YLPBusinessDetails: Decodable {
  let id: String?
  let image_url: String?
  let name: String?
  let is_closed: Bool?
  let url: String?
  let display_phone: String?
  let review_count: Int?
  let categories: [Categories]?
  let rating: Double?
  let coordinates: Location?
  let photos: [String]?
  let price: String?
  let hours: [Hours]?
}


var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
