//
//  AnswersViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 09/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift

protocol AnswersViewModelDelegate: class {
    
    var productName: String? { get }
    
    var imageURL: URL? { get }
}

class AnswersViewModel: ViewModelType {
    
    weak var viewController: AnswersViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private let answers: [BVAnswer]
    
    private let product: BVProduct
    
    init(answers: [BVAnswer], product: BVProduct) {
        self.answers = answers
        self.product = product
    }
}

extension  AnswersViewModel: AnswersViewModelDelegate {
    var productName: String? {
        return self.product.productId
    }
    
    var imageURL: URL? {
        return self.product.imageUrl?.value
    }
}
