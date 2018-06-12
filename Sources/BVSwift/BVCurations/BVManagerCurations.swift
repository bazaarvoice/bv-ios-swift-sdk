//
//
//  BVManagerCurations.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVManager: BVCurationsConfiguration
extension BVManager {
  internal static
  var curationsConfiguration: BVCurationsConfiguration? {
    get {
      return BVManager.sharedManager.getConfiguration()
    }
  }
}
