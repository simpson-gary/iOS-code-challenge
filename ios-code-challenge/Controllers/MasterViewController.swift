//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

class MasterViewController: UITableViewController{
  
  @objc var detailViewController: DetailViewController?
  let locationManager = CLLocationManager()//Use for GPS permissions
  
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
    
    ///Enable GPS usage
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
    
//    let query = YLPSearchQuery(location: "5550 West Executive Dr. Tampa, FL 33609")

  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
    super.viewDidAppear(animated)
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
  
  //MARK: - Search
  func executeSEarch(query: YLPSearchQuery) {
    AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
      guard let strongSelf = self,
        let dataSource = strongSelf.dataSource,
        let businesses = searchResult?.businesses else {
          return
      }
      dataSource.setObjects(businesses)
      dataSource.setDetailView(self)
      strongSelf.tableView.reloadData()
    })
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
      self.executeSEarch(query: query)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error:: \(error)")
  }
  
}

