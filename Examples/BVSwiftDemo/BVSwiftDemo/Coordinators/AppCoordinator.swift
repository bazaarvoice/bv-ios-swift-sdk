//
//  AppCoordinator.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit
import BVSwift

class AppCoordinator: Coordinator {
    
    enum AppNavigation: AppNavigator {
        
        case productDisplayPage(productId: String)
        
        case questions(productId: String, product: BVProduct)
    }
    
    // MARK:- Initializers
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {

        super.start()

        // 1. Create View Controller
        let homeViewController = HomeViewController.instantiate()
        homeViewController.navigationItem.titleView = HomeViewController.createTitleLabel()

        // 2. Create View Model
        let viewModel = HomeViewModel()
        viewModel.coordinator = self
        viewModel.viewController = homeViewController
        
        // 3. Assign View Model and Push View Controller
        homeViewController.viewModel = viewModel
        self.navigationController.pushViewController(homeViewController, animated: true)        
    }
    
    override func navigateTo(_ scene: AppNavigator) {
        
        guard let navigationScene = scene as? AppNavigation else { return }
        
        switch navigationScene {
            
        case .productDisplayPage(let productId):
            self.showProductDisplayPage(productId: productId)
            
        case .questions(let productId, let product):
            self.showQuestionsScreen(productId: productId, product: product)

        }
    }
    
    // MARK:- Private methods
    private func showProductDisplayPage(productId: String) {
        
        // 1. Create View Controller
        let productDisplayPageViewController = ProductDisplayPageViewController.instantiate()
        productDisplayPageViewController.navigationItem.titleView = ProductDisplayPageViewController.createTitleLabel()
        
        // 2. Create View Model
        // TODO:- Hard coded to "test1" as the product ids returned by recommendations API are not having data in BVProductQuery.
        let productDisplayPageViewModel = ProductDisplayPageViewModel(productId: "test1")
        productDisplayPageViewModel.coordinator = self
        productDisplayPageViewModel.viewController = productDisplayPageViewController
        
        // 3. Assign View Model and Push View Controller
        productDisplayPageViewController.viewModel = productDisplayPageViewModel
        self.navigationController.pushViewController(productDisplayPageViewController, animated: true)
    }
    
    private func showQuestionsScreen(productId: String, product: BVProduct) {
        
        // 1. Create View Controller
        let questionsViewController = QuestionsTableViewController.instantiate()
        questionsViewController.navigationItem.title = "Questions"
        
        // 2. Create View Model
        let questionsViewModel = QuestionsViewModel(productId: productId,
                                                    product: product)
        questionsViewModel.coordinator = self
        questionsViewModel.viewController = questionsViewController
        
        // 3. Assign and navigate
        questionsViewController.viewModel = questionsViewModel
        self.navigationController.pushViewController(questionsViewController, animated: true)
    }
}
