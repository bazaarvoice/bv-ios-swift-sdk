//
//
//  BVFingerprint.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

#if !DISABLE_BVSDK_IDFA
import AdSupport
#endif

import Foundation

internal class BVFingerprint {
  
  private static var bvidUserDefaultsKey: String = "BVID_STORAGE_KEY"
  private static var nontrackingIDFA: String = "nontracking"
  
  private init() {}
  
  internal static let shared = BVFingerprint()
  
  internal var bvid: String {
    if let id: String =
      UserDefaults.standard.string(
        forKey: BVFingerprint.bvidUserDefaultsKey),
      0 < id.count {
      return id
    }
    
    let uuid: String = UUID().uuidString
    UserDefaults.standard.setValue(
      uuid, forKey: BVFingerprint.bvidUserDefaultsKey)
    UserDefaults.standard.synchronize()
    return uuid
  }
  
  internal var idfa: String? {
    #if !DISABLE_BVSDK_IDFA
    guard ASIdentifierManager.shared()
      .isAdvertisingTrackingEnabled else {
        return nil
    }
    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    #else
    return nil
    #endif
  }
  
  internal var nontrackingIDFA: String {
    return BVFingerprint.nontrackingIDFA
  }
}
