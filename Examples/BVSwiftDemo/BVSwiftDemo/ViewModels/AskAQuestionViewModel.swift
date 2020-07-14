//
//  AskAQuestionViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 14/07/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol AskAQuestionViewModelDelegate: class {
  func submitQuestionTapped()
}

class AskAQuestionViewModel: ViewModelType {
  
  weak var viewController: AskAQuestionViewControllerDelegate?
  
  weak var coordinator: Coordinator?
    
  
}

// MARK:- AskAQuestionViewModelDelegate methods
extension AskAQuestionViewModel: AskAQuestionViewModelDelegate {
    
    func submitQuestionTapped() {
        
    }
}
