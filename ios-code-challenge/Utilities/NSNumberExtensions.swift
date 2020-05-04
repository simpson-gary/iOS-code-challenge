//
//  NSNumberExtensions.swift
//  ios-code-challenge
//
//  Created by Jinglz on 5/4/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import Foundation

extension NSNumber {
  /**
   Returns the converted Double (meters) representation of the given (miles) double.
   
   */
  func getMiles() -> String {
    let meters = Measurement(value: Double(truncating: self), unit: UnitLength.meters)
    let miles = meters.converted(to: UnitLength.miles)
    let mf = MeasurementFormatter()
    mf.unitOptions = .providedUnit
    mf.numberFormatter.maximumFractionDigits = 2
    let metersStr = mf.string(from: miles)
    return metersStr
  }
}
