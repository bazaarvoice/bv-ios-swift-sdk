//
//  BVModule.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 28/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

enum BVModule: Int, CaseIterable, AppNavigator {
    
    case conversations
    case curations
    case recommendations
    
    var titleText: String {
        switch self {
        case .conversations: return "Conversations"
        case .curations: return "Curations"
        case .recommendations: return "Recommendations"
        }
    }
    
}
