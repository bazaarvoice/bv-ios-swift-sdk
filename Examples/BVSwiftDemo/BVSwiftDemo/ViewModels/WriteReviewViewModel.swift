//
//  WriteReviewViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 14/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

protocol WriteReviewViewModelDelegate: class {
    
}

class WriteReviewViewModel: ViewModelType {
    
    weak var viewController: WriteReviewViewControllerDelegate?
    
    var coordinator: Coordinator?
    
    private let productId: String
    
    private let product: BVProduct
    
    init(productId: String, product: BVProduct) {
        self.productId = productId
        self.product = product
    }
    
}
