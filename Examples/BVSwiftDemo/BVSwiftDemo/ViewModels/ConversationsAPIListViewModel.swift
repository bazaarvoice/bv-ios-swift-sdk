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
    var numberOfRows: Int { get }
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String
}

class ConversationsAPIListViewModel: ViewModelType {    
    
    weak var viewController: ConversationsAPIListViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private enum ConversationsAPI: String, CaseIterable {
        case author = "Author"
        case review = "Review"
        case reviewHighlights = "Review Highlights"
    }
}

extension ConversationsAPIListViewModel: ConversationsAPIListViewModelDelegate {
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return ConversationsAPI.allCases.count
    }
    
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        return ConversationsAPI.allCases[indexPath.row].rawValue
    }
}
