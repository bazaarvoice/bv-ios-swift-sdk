//
//  AppDelegate.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    // Override point for customization after application launch.
    
    //#warning See bvsdk_config_staging.json and bvsdk_config_product.json in the project for API key and client ID settings.
    BVManager.sharedManager.logLevel = .error
    return true
  }
}

