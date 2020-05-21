//
//  HomeViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
    func didTapShowNextButton()
}

class HomeViewModel: BVSwiftViewModelType {
    weak var viewController: HomeViewModelDelegate?
    
    weak var coordinator: Coordinator?
}

extension HomeViewModel: HomeViewModelDelegate {
    func didTapShowNextButton() {
        coordinator?.navigateTo(AppCoordinator.ModuleNavigation.conversations)
    }
}
