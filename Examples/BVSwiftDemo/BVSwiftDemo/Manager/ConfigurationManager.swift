//
//  ConfigurationManager.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 27/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

enum Environment: String {
    case staging
    case production
    case mock
}

class ConfigurationManager: NSObject {
    
    //Shared Instance
    static let sharedInstance = ConfigurationManager()
    
    //Current scheme
    private let environment: Environment
    
    //Required Keys and IDs
    private let clientId: String = "REPLACE_ME" // <--- Add your clientId key here.
    private let conversationsPassKey: String = "REPLACE_ME" // <--- Add your conversations API key here.
    private let curationsPassKey: String = "REPLACE_ME" // <--- Add your curations API key here.
    private let recommendationPassKey: String = "REPLACE_ME" // <--- Add your recommendation API key here.
    
    //For ReviewHighligts
    let reviewHighlightsProductId: String = "REPLACE_ME" // <--- Add your reviewHighlights ProductId here.
    let reviewHighlightsClientId: String = "REPLACE_ME" // <--- Add your reviewHighlights ClientId here.
    
    //ForAuthor
    let authorId: String = "REPLACE_ME" // <--- Add your authorId here.
    
    //ForProgressiveSubmission
    let submissionSessionToken: String = "REPLACE_ME" // <--- Add your submission Session Token here.
    
    //Configurations
    var conversationsConfig: BVConversationsConfiguration!
    var curationsConfig: BVCurationsConfiguration!
    var recommendationConfig: BVRecommendationsConfiguration!
    var reviewHighlightsConfig: BVReviewHighlightsConfiguration!
    
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
            
            //Conversation Configuration
            let analyticsConfig: BVAnalyticsConfiguration =  .dryRun(configType: .staging(clientId: self.clientId))
            self.conversationsConfig = BVConversationsConfiguration.all(clientKey: self.conversationsPassKey, configType: .staging(clientId: self.clientId), analyticsConfig: analyticsConfig)
            
            // Curations Configuration
            self.curationsConfig = BVCurationsConfiguration.display(
                clientKey: self.curationsPassKey,
                configType: .production(clientId: self.clientId),
                analyticsConfig: analyticsConfig)
            
            //Recommendation Configuration
            self.recommendationConfig = BVRecommendationsConfiguration.display(
                clientKey: self.recommendationPassKey,
                configType: .production(clientId: self.clientId),
                analyticsConfig: analyticsConfig)
            
            //ReviewHighlights Configuration
            self.reviewHighlightsConfig = BVReviewHighlightsConfiguration.display(
                configType: .staging(clientId: self.reviewHighlightsClientId),
                analyticsConfig: analyticsConfig)
            
        case .production :
            
            //Conversation Configuration
            let analyticsConfig: BVAnalyticsConfiguration =  .dryRun(configType: .production(clientId: self.clientId))
            self.conversationsConfig = BVConversationsConfiguration.all(clientKey: self.conversationsPassKey, configType: .production(clientId: self.clientId), analyticsConfig: analyticsConfig)
            
            // Curations Configuration
            self.curationsConfig = BVCurationsConfiguration.display(
                clientKey: self.curationsPassKey,
                configType: .production(clientId: self.clientId),
                analyticsConfig: analyticsConfig)
            
            //Recommendation Configuration
            self.recommendationConfig = BVRecommendationsConfiguration.display(
                clientKey: self.recommendationPassKey,
                configType: .production(clientId: self.clientId),
                analyticsConfig: analyticsConfig)
            
            //ReviewHighlights Configuration
            self.reviewHighlightsConfig = BVReviewHighlightsConfiguration.display(
                configType: .production(clientId: self.reviewHighlightsClientId),
                analyticsConfig: analyticsConfig)
            
        case .mock:
            
            MockDataManager.sharedInstance.setupMocking()
            
            //Conversation Configuration
            let analyticsConfig: BVAnalyticsConfiguration =  .dryRun(configType: .staging(clientId: self.clientId))
            self.conversationsConfig = BVConversationsConfiguration.all(clientKey: self.conversationsPassKey, configType: .staging(clientId: self.clientId), analyticsConfig: analyticsConfig)
            
            // Curations Configuration
            self.curationsConfig = BVCurationsConfiguration.display(
                clientKey: self.curationsPassKey,
                configType: .production(clientId: self.clientId),
                analyticsConfig: analyticsConfig)
            
            //Recommendation Configuration
            self.recommendationConfig = BVRecommendationsConfiguration.display(
                clientKey: self.recommendationPassKey,
                configType: .production(clientId: self.clientId),
                analyticsConfig: analyticsConfig)
            
            //ReviewHighlights Configuration
            self.reviewHighlightsConfig = BVReviewHighlightsConfiguration.display(
                configType: .staging(clientId: self.reviewHighlightsClientId),
                analyticsConfig: analyticsConfig)
            
        } //end of case
    }
    
} //end of class

