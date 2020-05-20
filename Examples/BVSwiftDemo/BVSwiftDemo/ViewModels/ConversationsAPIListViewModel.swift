//
//  ConversationsAPIListViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol ConversationsAPIListViewModelDelegate: class {
    func getData()
}

class ConversationsAPIListViewModel: ConversationsAPIListViewModelDelegate {
    
    weak var viewControllerDelegate: ConversationsAPIListViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private enum ConversationsAPI {
        case author
        case review
        case reviewHighlights
    }
    
    func getData() {
        print("Inside getData")
    }
}
