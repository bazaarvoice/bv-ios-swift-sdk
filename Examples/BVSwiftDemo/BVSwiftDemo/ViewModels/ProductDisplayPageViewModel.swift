//
//  ProductDisplayPageViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 02/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift

protocol ProductDisplayPageViewModelDelegate: class {
    
    func fetchProductDisplayPageDetails()
    
}

class ProductDisplayPageViewModel: ViewModelType {
    
    weak var viewController: ProductDisplayPageViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private let productId: String
    private var product: BVProduct?
    
    init(productId: String) {
        self.productId = productId
    }
}

// MARK:- ProductDisplayPageViewModelDelegate
extension ProductDisplayPageViewModel: ProductDisplayPageViewModelDelegate{
    
    func fetchProductDisplayPageDetails() {
        
        let productQuery = BVProductQuery(productId: self.productId)
            .include(.questions)
            .include(.reviews)
            .configure(ConfigurationManager.sharedInstance.config)
            .handler { [weak self] (response: BVConversationsQueryResponse<BVProduct>) in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    if case .failure(let errors) = response {
                        let errorMessage = (errors.first as? BVError)?.message ?? "Something went wrong."
                        strongSelf.coordinator?.showAlert(title: "", message: errorMessage, handler: {
                            strongSelf.coordinator?.popBack()
                        })
                        return
                    }
                    
                    guard case let .success(_, products) = response else {
                        strongSelf.coordinator?.showAlert(title: "", message: "Something went wrong.", handler: {
                            strongSelf.coordinator?.popBack()
                        })
                        return
                    }
                    
                    strongSelf.product = products.first
                }
        }
        
        productQuery.async()
    }
    
}
