//
//  Config.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 21/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

enum Environment: String {
    case staging
    case production
}

class Config: NSObject {
    
    static let sharedInstance = Config()
    private let environment: Environment
    private let clientId: String = "apitestcustomer"
    private let conversationsPassKey: String = "kuy3zj9pr3n7i0wxajrzj04xo"
    var config: BVConversationsConfiguration!
    
    
    private override init() {
        
        if let currentConfigStr = Bundle.main.object(forInfoDictionaryKey: "ENV") as? String, let env = Environment.init(rawValue: currentConfigStr)  {
            
            self.environment = env
            
        }
        else {
            self.environment = .staging
        }
        
        super.init()
    } //end of init
    
    
    func setConfiguration() {
        switch self.environment {
            
        case .staging :
            let analyticsConfig: BVAnalyticsConfiguration =  .dryRun(configType: .staging(clientId: self.clientId))
            self.config = BVConversationsConfiguration.all(clientKey: self.conversationsPassKey, configType: .staging(clientId: self.clientId), analyticsConfig: analyticsConfig)
            
        case .production :
            let analyticsConfig: BVAnalyticsConfiguration =  .dryRun(configType: .production(clientId: self.clientId))
            self.config = BVConversationsConfiguration.all(clientKey: self.conversationsPassKey, configType: .production(clientId: self.clientId), analyticsConfig: analyticsConfig)
            
        } //end of case
    }
    
} //end of class
