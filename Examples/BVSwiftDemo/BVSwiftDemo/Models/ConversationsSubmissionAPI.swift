//
//  ConversationsSubmissionAPI.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 27/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

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
