//
//  ConversationsAPIListViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol ConversationsAPIListViewModelDelegate: class {
    
    var numberOfSections: Int { get }
    
    func titleForHeaderInSection(_ section: Int) -> String
    
    func numberOfRowsInSection(_ section: Int) -> Int
    
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String
}

class ConversationsAPIListViewModel: ViewModelType {
    
    private enum ConversationsSection: Int {
        case display
        case submission
        
        var headerTitle: String {
            switch self {
            case .display: return "Display APIs"
            case .submission: return "Submission APIs"
            }
        }
    }
    
    weak var viewController: ConversationsAPIListViewControllerDelegate?
    
    weak var coordinator: Coordinator?
}

// MARK:- ConversationsAPIListViewModelDelegate methods
extension ConversationsAPIListViewModel: ConversationsAPIListViewModelDelegate {
    var numberOfSections: Int {
        return 2
    }
    
    func titleForHeaderInSection(_ section: Int) -> String {
        
        guard let conversationsSection = ConversationsSection(rawValue: section) else {
            return ""
        }
        
        return conversationsSection.headerTitle
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        
        guard let conversationsSection = ConversationsSection(rawValue: section) else {
            return 0
        }
        
        switch conversationsSection {
        
        case .display:
            return ConversationsDisplayAPIs.allCases.count
        
        case .submission:
            return ConversationsSubmissionAPIs.allCases.count

        }
        
    }
    
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        
        guard let conversationsSection = ConversationsSection(rawValue: indexPath.section) else {
            return ""
        }
        
        switch conversationsSection {
        
        case .display:
            return ConversationsDisplayAPIs.allCases[indexPath.row].titleText
        
        case .submission:
            return ConversationsSubmissionAPIs.allCases[indexPath.row].titleText

        }
    }
}
