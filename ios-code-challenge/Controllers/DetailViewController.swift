//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

protocol UpdateMapView {
  func dropPinZoomIn(coordinate: CLLocationCoordinate2D, name: String)
}

class DetailViewController: BaseScrollableViewController {
  var mapHeightConstraint: NSLayoutConstraint?
  var imageWidthConstraint: NSLayoutConstraint?
  
  var initialLocation: CLLocation?
  let regionRadius: CLLocationDistance = 1000
  
  let searchCompleter = MKLocalSearchCompleter()
  
  static let favoritesKey = "iosCodeChallenge.favorites"
  static var favoritesList = [String]()
  
  var businessDetails: YLPBusinessDetails? {
    didSet {
      self.navigationController?.title = business?.name
      businessDetailsStack.isHidden = false
      updateFavoriteBarButtonState()
      debugPrint(business?.latitude ?? "ERROR NO LATITUDE")
      let coordinate = CLLocationCoordinate2DMake(business?.latitude as! CLLocationDegrees, business?.longitude as! CLLocationDegrees)
      
      self.dropPinZoomIn(coordinate: coordinate, name: business?.name ?? "")
      configureView()
    }
  }
  
  @objc var business: YLPBusiness? {
    didSet {
      self.navigationController?.title = business?.name
      businessDetailsStack.isHidden = false
      updateFavoriteBarButtonState()
      configureView()
    }
  }
  
  lazy private var divider: UIView = {
    let view = UIView.init(frame: .zero)
    view.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    view.widthAnchor.constraint(equalToConstant: view.frame.height * 0.7).isActive = true
    return view
  }()
  
  var imageView: UIImageView? = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    imgView.clipsToBounds = true
    imgView.translatesAutoresizingMaskIntoConstraints = false
    return imgView
  }()
  
  lazy private var mapView: MKMapView = {
    let view = MKMapView.init(frame: .zero)
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let businessNameLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .headline)
    lbl.textAlignment = .left
    return lbl
  }()
  
  private let businessRatingCount : UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = .left
    label.text = "0"
    return label
  }()
  
  private let businessDistanceLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .body)
    lbl.textAlignment = .left
    lbl.numberOfLines = 0
    return lbl
  }()
  
  private let businessDescriptionLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .body)
    lbl.textAlignment = .left
    lbl.numberOfLines = 0
    return lbl
  }()
  
  private let businessCaptionLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
    lbl.textAlignment = .left
    return lbl
  }()
  
  
  @IBOutlet var detailDescriptionLabel: UILabel!
  lazy private var favoriteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Star-Outline"), style: .plain, target: self, action: #selector(onFavoriteBarButtonSelected(_:)))
  
  @objc var detailItem: NSDate?
  
  private var _favorite: Bool = false
  private var isFavorite: Bool {
    get {
      return _favorite
    }
  }
  
  lazy var businessDetailsStack: BaseBackgroundStackView = {
    let stack = BaseBackgroundStackView.init(arrangedSubviews: [divider, businessRatingCount, divider, businessDistanceLabel, divider, businessCaptionLabel])
    return stack
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollContentView.addSubview(imageView!)
    scrollContentView.addSubview(mapView)
    scrollContentView.addSubview(businessDetailsStack)
    
    DetailViewController.favoritesList = DetailViewController.loadFavoritesList()
    
    navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
    setLayout()
  }
  
  func setLayout() {
    imageView!.anchor(top: scrollContentView.topAnchor, leading: scrollContentView.leadingAnchor, bottom: nil, trailing: scrollContentView.trailingAnchor, padding: UIEdgeInsets.zero)
    imageView!.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
    
    mapView.anchor(top: imageView?.bottomAnchor, leading: scrollContentView.leadingAnchor, bottom: nil, trailing: scrollContentView.trailingAnchor)
    mapView.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
    
    businessDetailsStack.anchor(top: mapView.bottomAnchor, leading: scrollContentView.leadingAnchor, bottom: nil, trailing: scrollContentView.trailingAnchor)
  }
  
  private func setFavoriteStatus() {
    _favorite = DetailViewController.favoritesList.contains(business?.identifier ?? "")
  }
  
  private func configureView() {
    detailDescriptionLabel = UILabel.init()
    detailDescriptionLabel.text = business?.name ?? "No Name Set"
    
    businessNameLabel.text = business?.name
    businessRatingCount.text = "\(business?.price ?? "-") ∙ ★\(business?.rating.stringValue ?? "-") ∙ (\(business?.reviewCount ?? 0))"
    businessDistanceLabel.text = "\(business?.distance.getMiles() ?? "0 mi")* "
    businessCaptionLabel.text = business?.categories
    
    navigationItem.title = business?.name
    mapView.isHidden = false
  }
  
  private func updateFavoriteBarButtonState() {
    _favorite = DetailViewController.favoritesList.contains(business?.identifier ?? "")
    favoriteBarButtonItem.image = isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
  }
  
  @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
    _favorite.toggle()
    isFavorite ? DetailViewController.favoritesList.append(business!.identifier) :
      DetailViewController.favoritesList.removeAll(where: {$0 == business!.identifier})
    
    DetailViewController.saveFavoritesList(list: DetailViewController.favoritesList)
    
    updateFavoriteBarButtonState()
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

extension DetailViewController: UpdateMapView {
  func dropPinZoomIn(coordinate: CLLocationCoordinate2D, name: String){
      // Clear existing and add new pin.
      mapView.removeAnnotations(mapView.annotations)
      let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        
        mapView.addAnnotation(annotation)
      
        let span =  MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
