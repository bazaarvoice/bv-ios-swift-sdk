//
//  QuestionsViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 27/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol QuestionsViewModelDelegate: class {
    
}

class QuestionsViewModel: ViewModelType {
    
    weak var viewController: QuestionsTableViewControllerDelegate?
    
    weak var coordinator: Coordinator?
}

// MARK:- QuestionsViewModelDelegate
extension QuestionsViewModel: QuestionsViewModelDelegate {
    
}
