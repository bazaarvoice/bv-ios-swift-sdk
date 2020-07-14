//
//  AskAQuestionViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 14/07/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift

protocol AskAQuestionViewModelDelegate: class {
    
    var productName: String? { get }
    
    var productRating: Double? { get }
    
    var productImageURL: URL? { get }
    
    func submitQuestionTapped()
}

class AskAQuestionViewModel: ViewModelType {
    
    weak var viewController: AskAQuestionViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private let product: BVProduct
    
    init(product: BVProduct) {
        self.product = product
    }
}

// MARK:- AskAQuestionViewModelDelegate methods
extension AskAQuestionViewModel: AskAQuestionViewModelDelegate {
    
    var productName: String? {
        return self.product.name
    }
    
    var productRating: Double? {
        return self.product.reviewStatistics?.averageOverallRating
    }
    
    var productImageURL: URL? {
        return self.product.imageUrl?.value
    }
    
    func submitQuestionTapped() {
        
    }
}
