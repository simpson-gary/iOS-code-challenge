//
//  YLPBusinessDetails.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/4/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import Foundation

struct Location: Decodable {
  let latitude: Float?
  let longitude: Float?
}

struct DailyHours: Decodable {
  let is_overnight: Bool?
  let start: String?
  let end: String?
  let day: Int?
}

struct Categories: Decodable {
  let alias: String?
  let title: String?
}

struct Hours: Decodable {
  let open: [DailyHours]?
  let hours_type: String?
  let is_open_now: Bool?
}

struct YLPBusinessDetails: Decodable {
  let id: String?
  let image_url: String?
  let name: String?
  let is_closed: Bool?
  let url: String?
  let display_phone: String?
  let review_count: Int?
  let categories: [Categories]?
  let rating: Double?
  let coordinates: Location?
  let photos: [String]?
  let price: String?
  let hours: [Hours]?
}
