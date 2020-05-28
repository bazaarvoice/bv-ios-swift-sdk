//
//  HomeViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
    var numberOfSections: Int { get }
    var numberOfRows: Int { get }
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String
    func didSelectRowAt (indexPath: IndexPath)
}

class HomeViewModel: ViewModelType {
    
    weak var viewController: HomeViewModelDelegate?
    
    weak var coordinator: Coordinator?
}

extension HomeViewModel: HomeViewModelDelegate {
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return BVModule.allCases.count
    }
    
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        return BVModule.allCases[indexPath.row].titleText
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
        guard let displayModuleRow = BVModule(rawValue: indexPath.row) else {
           return
        }
        
        
        self.coordinator?.navigateTo(displayModuleRow)
    }
    
}

