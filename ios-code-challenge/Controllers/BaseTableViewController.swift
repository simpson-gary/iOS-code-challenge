//
//  BaseTableViewController.swift
//  ios-code-challenge
//
//  Created by Jinglz on 5/3/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

@objcMembers class BaseTableViewController<T, Cell: NXTBusinessTableViewCell>: UITableViewController {
  
  @objc var tabViewController: TabBarViewController?
  @objc var detailViewController: DetailViewController?
  
  let locationManager = CLLocationManager()//Use for GPS permissions
  var isLocationQuery = false
  
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

         tableView.dataSource = dataSource
         tableView.delegate = dataSource
         tableView.allowsSelection = true
      

      dataSource?.setDetailAction(tabViewController)
      //dataSource!.setDetailAction(#selector(self.transitionDetailView))
    }

  @objc func transitionDetailView() {
     let indexPath = tableView.indexPathForSelectedRow!
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
  
  //MARK: - SearchQuery
  func executeSearch(query: YLPSearchQuery, page: Bool = false) {
    showSpinner(onView: tableView)
    
    AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
      guard let strongSelf = self,
        let dataSource = strongSelf.dataSource,
        let businesses = searchResult?.businesses else {
          return
      }
      
      dataSource.appendObjects(businesses)
      
      strongSelf.tableView.reloadData()
      self?.removeSpinner()
    })
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
  
  func updateDataSource(_ objects: [YLPBusiness]) {
    debugPrint("BaseTableView:: updateDataSource with #\(objects.count).")
    dataSource?.appendObjects(objects)
  }
}
