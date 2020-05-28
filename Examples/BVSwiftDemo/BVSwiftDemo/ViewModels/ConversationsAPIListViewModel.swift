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
    
    func didSelectRowAtIndexPath(_ indexPath: IndexPath)
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
    
    private func performDisplayAPINavigationForRow(_ row: Int) {
        
        guard let conversationsDisplayRow = ConversationsDisplayAPI(rawValue: row) else {
            return
        }
        
        self.coordinator?.navigateTo(conversationsDisplayRow)
    }
    
    private func performSubmissionAPINavigationForRow(_ row: Int) {
        
        guard let conversationsSubmissionRow = ConversationsSubmissionAPI(rawValue: row) else {
            return
        }
        
        self.coordinator?.navigateTo(conversationsSubmissionRow)
    }
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
            return ConversationsDisplayAPI.allCases.count
            
        case .submission:
            return ConversationsSubmissionAPI.allCases.count
            
        }
        
    }
    
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        
        guard let conversationsSection = ConversationsSection(rawValue: indexPath.section) else {
            return ""
        }
        
        switch conversationsSection {
            
        case .display:
            return ConversationsDisplayAPI.allCases[indexPath.row].titleText
            
        case .submission:
            return ConversationsSubmissionAPI.allCases[indexPath.row].titleText
            
        }
    }
    
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        
        guard let conversationsSection = ConversationsSection(rawValue: indexPath.section) else {
            return
        }
        
        switch conversationsSection {
            
        case .display:
            self.performDisplayAPINavigationForRow(indexPath.row)
            
        case .submission:
            self.performSubmissionAPINavigationForRow(indexPath.row)
            
        }
    }
}
