//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import MapKit

/*
 2. When you tap on a business cell, show the details of the business on the right side.  Include the following fields
 a. Name
 b. Categories
 c. Rating
 d. Review Count
 e. Price
 f. Thumbnail
 */

class DetailViewController: UIViewController {
  
  var initialLocation: CLLocation?
  let regionRadius: CLLocationDistance = 1000
  
  ////  @objc func setBusiness(biz: YLPBusiness) {
  ////    business = biz
  ////  }
  //
  //  @objc var business: YLPBusiness? {
  //    set { self.business = newValue }
  //    get { return self.business }
  //  }
  
  @objc var business: YLPBusiness? {
    didSet {
      self.navigationController?.title = business?.name
      businessDetailsStack.isHidden = false
      configureView()
    }
  }
  
  var imageView: UIImageView? = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    imgView.clipsToBounds = true
    imgView.backgroundColor = UIColor.red//UIColor.gray.withAlphaComponent(0.5)
    imgView.layer.cornerRadius = CGFloat(4.0)
    imgView.translatesAutoresizingMaskIntoConstraints = false
    return imgView
  }()
  
  private let businessNameLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .headline)
    lbl.textAlignment = .left
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
  
  let businessDetailsStack: BaseBackgroundStackView = {
    let stack = BaseBackgroundStackView.init(frame: .zero)
    return stack
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(imageView!)
    
    //        configureView()
    navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
    setLayout()
  }
  
  func setLayout() {
    imageView!.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
    imageView!.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
      
  }
  
  
  private func configureView() {
    //guard let detailItem = detailItem else { return }
    detailDescriptionLabel = UILabel.init()
    detailDescriptionLabel.text = business?.name ?? "No Name Set"
    //navigationController?.title = business?.name
    navigationItem.title = business?.name
    
  }
  
  func setDetailItem(newDetailItem: YLPBusiness) {
    //guard detailItem != newDetailItem else { return }
    //detailItem = newDetailItem
    //configureView()
  }
  
  private func updateFavoriteBarButtonState() {
    favoriteBarButtonItem.image = isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
  }
  
  @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
    _favorite.toggle()
    updateFavoriteBarButtonState()
  }
}


/**
 Provides a base UIStackView with rounded corners & UIView with background blurr effect applied.
 
 - Important:
 Defaults isHidden = true.
 */
class BaseBackgroundStackView: UIStackView {
  let margin: CGFloat = 8
  
  var backgroundView: UIView = {
    let view = UIView()
    //view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
    view.layer.cornerRadius = 8.0
    view.layer.borderWidth = 2.0
    if #available(iOS 13.0, *) {
      view.layer.borderColor = UIColor.systemFill.cgColor
    } else {
      // Fallback on earlier versions
      view.layer.borderColor = UIColor.lightGray.cgColor
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    spacing = 4.0
    layoutMargins = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
    
    //clipsToBounds = true
    isLayoutMarginsRelativeArrangement = true
    alignment = .leading
    distribution = UIStackView.Distribution.fill
    axis = .vertical
    
    isHidden = true
    setupBackgroundView()
    setupBlurEffect()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupBlurEffect() {
    var blurEffect: UIBlurEffect
    
    if #available(iOS 13.0, *) {
      blurEffect = UIBlurEffect(style: .systemThickMaterial)
    } else {
      blurEffect = UIBlurEffect(style: .dark)
    }
    
    let visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    backgroundView.addSubview(visualEffectView)
    visualEffectView.anchorToFillSuperView()
    visualEffectView.alpha = 0.75
  }
  
  func setupBackgroundView() {
    insertSubview(backgroundView, at: 0)
    backgroundView.anchorToFillSuperView()
    backgroundView.clipsToBounds = true
  }
}
