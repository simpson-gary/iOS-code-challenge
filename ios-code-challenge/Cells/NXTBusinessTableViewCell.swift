//
//  BusinessTableViewCell.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/1/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

class NXTBusinessTableViewCell: UITableViewCell {
  
  @objc var business: YLPBusiness? {
    didSet {
      businessNameLabel.text = business?.name
      businessRatingCount.text = "★\(business?.rating.stringValue ?? "-") ∙ (\(business?.reviewCount ?? 0))"
      businessMilesLabel.text = "\(business?.distance.getMiles() ?? "0m")"
      businessCaptionLabel.text = business?.categories
      businessImage.image = business?.image
    }
  }
  
  private let businessNameLabel : UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.preferredFont(forTextStyle: .headline)
    lbl.textAlignment = .left
    return lbl
  }()
  
  private let businessMilesLabel : UILabel = {
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
  
  var businessRatingCount : UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = .left
    label.text = "0"
    return label
  }()
  
  @objc let businessImage : UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFill
    imgView.clipsToBounds = true
    imgView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    imgView.layer.cornerRadius = CGFloat(4.0)
    return imgView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(businessImage)
    addSubview(businessNameLabel)
    addSubview(businessMilesLabel)
    addSubview(businessCaptionLabel)
    addSubview(businessRatingCount)
    
    businessImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 80, height: 0, enableInsets: false)
    businessNameLabel.anchor(top: topAnchor, left: businessImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0/*frame.size.width / 2*/, height: 0, enableInsets: false)
    businessMilesLabel.anchor(top: businessNameLabel.bottomAnchor, left: businessImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0/*frame.size.width / 2*/, height: 0, enableInsets: false)
    
    businessCaptionLabel.anchor(top: businessMilesLabel.bottomAnchor, left: businessImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0/*frame.size.width / 2*/, height: 0, enableInsets: false)
    
    let stackView = UIStackView(arrangedSubviews: [businessRatingCount])
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    stackView.spacing = 5
    addSubview(stackView)
    stackView.anchor(top: businessNameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
