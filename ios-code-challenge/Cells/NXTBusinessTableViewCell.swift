//
//  BusinessTableViewCell.swift
//  ios-code-challenge
//
//  Created by Jinglz on 5/1/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import UIKit

@objcMembers class NXTBusinessTableViewCell: UITableViewCell {

//    var nameLabel: String! {
//      didSet {
//        debugPrint("Setting nameLabel")
//        textLabel?.text = nameLabel
//      }
//    }
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      //self.imageView?.sizeToFit()
      self.imageView?.translatesAutoresizingMaskIntoConstraints = false
      self.imageView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
      self.imageView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
      self.imageView?.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

/*
class BusinessTableObjectDataSource: NSObject, UITableViewDataSource {
  var objects = [Any]()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  

}
*/

