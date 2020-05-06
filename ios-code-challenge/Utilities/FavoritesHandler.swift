//
//  FavoritesHandler.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/4/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import Foundation
//
//struct Favorite: Codable {
//  var business: YLPBusiness
//  init(business: YLPBusiness) {
//    self.business = business
//  }
//  
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKey.self)
//    try container
//  }
//}

class Favorite: NSObject, NSCoding {
  // MARK: Properties
  var business: YLPBusiness?

  // MARK: Archiving Paths
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Favorites")

  // MARK: Initialization
  init?(business: YLPBusiness?) {
    // Initialize stored properties
    self.business = business

    // Must call initilizer before returning nil.
    super.init()
  }

  // MARK: Types
  struct PropertyKey {
    static let businessKey = "business"
  }

  // MARK: NSCoding
  func encode(with aCoder: NSCoder) {
    aCoder.encode(business, forKey: PropertyKey.businessKey)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let business = aDecoder.decodeObject(forKey: PropertyKey.businessKey) as? YLPBusiness

    // Must call designated initilizer.
    self.init(business: business)
  }

}


import Foundation
//struct to hold VisualizationImages
struct Favorites {
    static var global = [Favorite]()
}

class FavoritesHandler: NSObject {

    var favorites = [Favorite]()
    
    func setFavorites(_ faves : [Favorite]) {
        favorites = faves
        
        // saveFavorites on different thread for performance
        let priority = DispatchQoS.QoSClass.default
        DispatchQueue.global(qos: priority).async {
            // do some task
            self.saveFavorites()
            self.getFavorites()
            DispatchQueue.main.async {
                // update some UI
            }
        }
    }
    
    func getFavorites() {
        if (loadFavorites() != nil && loadFavorites()?.count != 0) {
            print("Favorites found on device  " + String(describing: loadFavorites()?.count) )
            let loadedVFavorites = loadFavorites()
            favorites = loadedVFavorites!
            Favorites.global = favorites
        } else {
            favorites = [Favorite]()
            Favorites.global = favorites
        }
    }
    
    // MARK: NSCoding
   private func saveFavorites() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favorites, toFile: Favorite.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save visualizationImages...")
        } else {
            print("Saved :-) visualizationImages...")
        }
    }
    
    private func loadFavorites() -> [Favorite]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Favorite.ArchiveURL.path) as? [Favorite]
    }
    
}
