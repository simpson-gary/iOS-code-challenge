//
//  BusinessTableViewCell.swift
//  ios-code-challenge
//
//  Created by Jinglz on 5/1/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

@objcMembers class NXTBusinessTableViewCell: UITableViewCell {
  
  var business: YLPBusiness? {
    didSet {
      businessNameLabel.text = business?.name
      businessRatingCount.text = "★\(business?.rating.stringValue ?? "-") ∙ (\(business?.reviewCount ?? 0))"
      businessDescriptionLabel.text = "\(business?.distance ?? 0)* "
      businessCaptionLabel.text = business?.categories
    }
  }
  
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
  
  private let decreaseButton : UIButton = {
    let btn = UIButton(type: .custom)
    btn.backgroundColor = .blue
    return btn
  }()
  
  private let increaseButton : UIButton = {
    let btn = UIButton(type: .custom)
    btn.backgroundColor = .red
    return btn
  }()
  var businessRatingCount : UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = .left
    label.text = "1"
    return label
  }()
  
  let businessImage : UIImageView = {
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
    addSubview(businessDescriptionLabel)
    addSubview(businessCaptionLabel)
    addSubview(decreaseButton)
    addSubview(businessRatingCount)
    addSubview(increaseButton)
    
    businessImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 80, height: 0, enableInsets: false)
    businessNameLabel.anchor(top: topAnchor, left: businessImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0/*frame.size.width / 2*/, height: 0, enableInsets: false)
    businessDescriptionLabel.anchor(top: businessNameLabel.bottomAnchor, left: businessImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0/*frame.size.width / 2*/, height: 0, enableInsets: false)
    
    businessCaptionLabel.anchor(top: businessDescriptionLabel.bottomAnchor, left: businessImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0/*frame.size.width / 2*/, height: 0, enableInsets: false)
    
    let stackView = UIStackView(arrangedSubviews: [businessRatingCount])// [decreaseButton,businessRatingCount,increaseButton])
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    stackView.spacing = 5
    addSubview(stackView)
    stackView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 70, enableInsets: false)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}


