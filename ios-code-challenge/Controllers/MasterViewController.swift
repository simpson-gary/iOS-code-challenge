//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

class MasterViewController: UITableViewController, UISearchBarDelegate {
  
  @objc var detailViewController: DetailViewController?
  let locationManager = CLLocationManager()//Use for GPS permissions
  
  var isLocationQuery = false
  
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
  
  lazy private var dataSource: NXTDataSource? = {
    guard let dataSource = NXTDataSource(objects: nil) else { return nil }
    dataSource.tableViewDidReceiveData = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.tableView.reloadData()
    }
    return dataSource
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    splitViewController?.preferredDisplayMode = .allVisible
    
    tableView.dataSource = dataSource
    tableView.delegate = dataSource
    tableView.allowsSelection = true
    
    searchBar.delegate = self
    self.navigationItem.titleView = searchBar
    
    ///Enable GPS usage
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
      
    setLayout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
    super.viewDidAppear(animated)
  }
  
  
  func setLayout() {
      
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    debugPrint("MasterView:: prepareForSegue #\(segue.identifier ?? "").")
    
    if segue.identifier == "showDetail" {
      guard let indexPath = tableView.indexPathForSelectedRow, let controller = segue.destination as? DetailViewController
        else {
          detailViewController = DetailViewController()
          debugPrint("MasterView:: prepareForSegue RETURN.")
          //transitionDetailView(indexPath: indexPath)
          return
      }
      detailViewController = controller
      transitionDetailView(indexPath: indexPath)
    }
  }
  
  @objc func transitionDetailView(indexPath: IndexPath) {
    detailViewController!.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    detailViewController!.navigationItem.leftItemsSupplementBackButton = true
    
    
    let cell = tableView.cellForRow(at: indexPath) as! NXTBusinessTableViewCell
    let business = cell.business
    
    debugPrint("MasterView:: transitionDetailView: business = #\(cell.business?.name ?? "") tapped.")
    detailViewController?.business = business
    let image = cell.businessImage.image?.cgImage?.copy()
    detailViewController?.imageView!.image = UIImage.init(cgImage: image!)
    
    //Show detailView for portriat iPhone
    if splitViewController?.isCollapsed ?? false {
      let detailNavController = detailViewController?.navigationController
      splitViewController?.showDetailViewController(detailNavController!, sender: self)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    debugPrint("MasterView:: cell #\(indexPath.item) tapped.")
    transitionDetailView(indexPath: indexPath)
  }
  
  //MARK: - SearchQuery
  func executeSearch(query: YLPSearchQuery, page: Bool = false) {
    query.limit = 35
    
    AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
      guard let strongSelf = self,
        let dataSource = strongSelf.dataSource,
        let businesses = searchResult?.businesses else {
          return
      }
      
      !page ? dataSource.setObjects(businesses) : dataSource.appendObjects(businesses)
      dataSource.setDetailView(self)
      self!.totalResults = searchResult?.total ?? UInt(businesses.count)
      
      strongSelf.tableView.reloadData()
    })
  }
  
  //MARK: - SearchBar
   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
     debugPrint("MasterView:: searchBarTextDidBeginEditing #\(searchBar.text ?? "").")
    
     if searchBar.text!.count < 0 {
       searchActive = true;
     }
   }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    debugPrint("MasterView:: searchBarTextDidEndEditing #\(searchBar.text ?? "").")
    searchActive = false;
    
    guard let searchBarText = searchBar.text else { return }
    searchString = searchBarText
    
    let query = YLPSearchQuery(location: searchBarText)
   }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    debugPrint("MasterView:: searchBarSearchButtonClicked #\(searchBar.text ?? "").")
    
    if (searchActive) {
      executeTextSearch()
    }
    
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    debugPrint("MasterView:: searchBarCancelButtonClicked #\(searchBar.text ?? "").")
      searchActive = false;
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    debugPrint("MasterView:: textDidChange #\(searchBar.text ?? "").")
    guard let searchBarText = searchBar.text else { return }
    searchString = searchBarText
    
    searchActive = true
    if timer != nil && timer!.isValid {
      debugPrint("MasterView:: timer.invalidate()")
      timer?.invalidate()
    }
    
    timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(executeTextSearch), userInfo: nil, repeats: false)
    RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
  }
  
  @objc func executeTextSearch() {
    debugPrint("MasterView:: executeTextSearch #\(searchBar.text ?? "").")
    guard let searchBarText = searchBar.text else { return }
    let query = YLPSearchQuery(location: searchBarText)
    searchString = searchBarText
    isLocationQuery = false
    executeSearch(query: query)
    searchActive = false
    timer!.invalidate()
  }
  
  @objc func executePageQuery() {
    var query: YLPSearchQuery?
    
    if isLocationQuery {
      query = YLPSearchQuery(coordinates: locationManager.location!)
    } else {
      query = YLPSearchQuery(location: "searchBarText")
    }
    
    debugPrint("MasterView:: executePageQuery #\(tableView.numberOfRows(inSection: 0)).")
    query!.offset = NSNumber.init(integerLiteral: tableView.numberOfRows(inSection: 0))
    executeSearch(query: query!, page: true)
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
    print("error:: \(error)")
  }
}

