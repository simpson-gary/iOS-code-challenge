//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

class MasterViewController: BaseTableViewController<Any, NXTBusinessTableViewCell>, UISearchBarDelegate {
  var searchActive: Bool = true
  var searchString: String?
  var timer: Timer?
  var totalResults: UInt = 0
  
  lazy var searchBar: UISearchBar! = {
    let bar = UISearchBar(frame: .zero)
    bar.placeholder = "Search"
    bar.translatesAutoresizingMaskIntoConstraints = false
    return bar
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
    
    ///Enable GPS usage
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
    super.viewDidAppear(animated)
    
    self.tabBarController?.navigationItem.titleView = searchBar
  }
  
  //MARK: - SearchBar
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    if searchBar.text!.count < 0 {
      searchActive = true;
    }
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false;
    
    guard let searchBarText = searchBar.text else { return }
    searchString = searchBarText
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if (searchActive) {
      executeTextSearch()
    }
    
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let searchBarText = searchBar.text else { return }
    searchString = searchBarText
    
    searchActive = true
    if timer != nil && timer!.isValid {
      timer?.invalidate()
    }
    
    timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(executeTextSearch), userInfo: nil, repeats: false)
    RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
  }
  
  @objc func executeTextSearch() {
    guard let searchBarText = searchBar.text else { return }
    let query = YLPSearchQuery(location: searchBarText)
    searchString = searchBarText
    isLocationQuery = false
    executeSearch(query: query)
    searchActive = false
    timer!.invalidate()
  }
}

//MARK: - Location Extensions
///Used for locations permission.
extension MasterViewController : CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager.requestLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if let location = locations.first {
      let query = YLPSearchQuery(coordinates: location)
      query.parameters()
      isLocationQuery = true
      self.executeSearch(query: query)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint("ERROR:: \(error)")
  }
}
