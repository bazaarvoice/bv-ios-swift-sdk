//
//  BaseViewControllerProtocol.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol ViewControllerModelable {
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
}

typealias ViewControllerType = ViewControllerModelable & Storyboarded
