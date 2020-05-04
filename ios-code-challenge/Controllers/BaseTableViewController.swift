//
//  BaseTableViewController.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/3/20.
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
  }
  
  //MARK: - SearchQuery
  func executeSearch(query: YLPSearchQuery, page: Bool = false) {
    AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
      guard let strongSelf = self,
        let dataSource = strongSelf.dataSource,
        let businesses = searchResult?.businesses else {
          return
      }
      
      dataSource.appendObjects(businesses)
      
      strongSelf.tableView.reloadData()
    })
  }
  
  @objc func executePageQuery() {
    var query: YLPSearchQuery?
    
    if isLocationQuery {
      query = YLPSearchQuery(coordinates: locationManager.location!)
    } else {
      query = YLPSearchQuery(location: "searchBarText")
    }
    
    query!.offset = NSNumber.init(integerLiteral: tableView.numberOfRows(inSection: 0))
    executeSearch(query: query!, page: true)
  }
  
  func updateDataSource(_ objects: [YLPBusiness]) {
    dataSource?.appendObjects(objects)
  }
}
