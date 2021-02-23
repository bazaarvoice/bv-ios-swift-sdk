//
//
//  BVFingerprint.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

#if !DISABLE_BVSDK_IDFA
import AdSupport
import AppTrackingTransparency
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
        if #available(iOS 14, *), ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            self.requestIDFA()
        }
        
        guard self.isAdvertisingTrackingEnabled() else {
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
    
    func isAdvertisingTrackingEnabled() -> Bool {
        
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus == .authorized
        }
        else {
            return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        }
    }
    
    @available(iOS 14, *)
    func requestIDFA() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: {_ in })
    }
    
}

