//
//  ProductDisplayPageViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 02/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol ProductDisplayPageViewModelDelegate: class {
    
    
}

class ProductDisplayPageViewModel: ViewModelType {
    
    weak var viewController: ProductDisplayPageViewControllerDelegate?
    
    weak var coordinator: Coordinator?
}

// MARK:- ProductDisplayPageViewModelDelegate
extension ProductDisplayPageViewModel: ProductDisplayPageViewModelDelegate{
    
    
}
