//
//  ConversationsAPIListViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol ConversationsAPIListViewModelDelegate: class {
    
}

class ConversationsAPIListViewModel: ConversationsAPIListViewModelDelegate {
    
    weak var viewControllerDelegate: ConversationsAPIListViewControllerDelegate?
    
    weak var coordinator: Coordinator?
}
