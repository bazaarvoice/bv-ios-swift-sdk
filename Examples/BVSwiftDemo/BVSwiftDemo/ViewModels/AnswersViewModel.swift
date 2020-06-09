//
//  AnswersViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 09/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol AnswersViewModelDelegate: class {
    
}

class AnswersViewModel: ViewModelType {
    
    weak var viewController: AnswersViewControllerDelegate?
    
    weak var coordinator: Coordinator?
}
