//
//  ConversationsAPIs.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 27/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

enum ConversationsDisplayAPI: Int, CaseIterable, AppNavigator {
    
    case authorQuery
    
    case commentQuery
    
    case commentsQuery
    
    case productQuery
    
    case productSearchQuery
    
    case productsQuery
    
    case productStatisticsQuery
    
    case questionQuery
    
    case questionSearchQuery
    
    case reviewQuery
    
    case reviewSearchQuery
    
    case multiProductQuery
    
    case reviewHighlights
    
    var titleText: String {
        
        switch self {
            
        case .authorQuery: return "Author Query"
            
        case .commentQuery: return "Comment Query"
            
        case .commentsQuery: return "Comments Query"
            
        case .productQuery: return "Product Query"
            
        case .productSearchQuery: return "Product Search Query"
            
        case .productsQuery: return "Products Query"
            
        case .productStatisticsQuery: return "Product Stats Query"
            
        case .questionQuery: return "Question Query"
            
        case .questionSearchQuery: return "Question Search Query"
            
        case .reviewQuery: return "Review Query"
            
        case .reviewSearchQuery: return "Review Search Query"
            
        case .multiProductQuery: return "Multi Product Query"
            
        case .reviewHighlights: return "Review Highlights Query"
            
        }
    }
    
}

enum ConversationsSubmissionAPI: Int, CaseIterable, AppNavigator {
    
    case answerSubmission
    
    case commentSubmission
    
    case feedbackSubmission
    
    case photoSubmission
    
    case questionSubmission
    
    case reviewSubmission
    
    case uasSubmission
    
    case progressiveSubmission
    
    var titleText: String {
        
        switch self {
            
        case .answerSubmission: return "Answer Submission"
            
        case .commentSubmission: return "Comment Submission"
            
        case .feedbackSubmission: return "Feedback Submission"
            
        case .photoSubmission: return "Photo Submission"
            
        case .questionSubmission: return "Question Submission"
            
        case .reviewSubmission: return "Review Submission"
            
        case .uasSubmission: return "UAS Submission"
            
        case .progressiveSubmission: return "Progressive Submission"
        }
    }
    
}
