//
//  AppCoordinator.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    enum AppNavigation: AppNavigator {
        
        case productDisplayPage(productId: String)
        
        case questions(productId: String)
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
        
        // 3. Assign View Model and Push View Controller
        homeViewController.viewModel = viewModel
        self.navigationController.pushViewController(homeViewController, animated: true)        
    }
    
    override func navigateTo(_ scene: AppNavigator) {
        
        guard let navigationScene = scene as? AppNavigation else { return }
        
        switch navigationScene {
            
        case .productDisplayPage(let productId):
            self.showProductDisplayPage(productId: productId)
            
        case .questions(let productId):
            self.showQuestionsScreen(productId: productId)

        }
    }
    
    // MARK:- Private methods
    private func showProductDisplayPage(productId: String) {
        
        // 1. Create View Controller
        let productDisplayPageViewController = ProductDisplayPageViewController.instantiate()
        productDisplayPageViewController.navigationItem.titleView = ProductDisplayPageViewController.createTitleLabel()
        
        // 2. Create View Model
        let productDisplayPageViewModel = ProductDisplayPageViewModel(productId: productId)
        productDisplayPageViewModel.coordinator = self
        productDisplayPageViewModel.viewController = productDisplayPageViewController
        
        // 3. Assign View Model and Push View Controller
        productDisplayPageViewController.viewModel = productDisplayPageViewModel
        self.navigationController.pushViewController(productDisplayPageViewController, animated: true)
    }
    
    private func showQuestionsScreen(productId: String) {
        
        // 1. Create View Controller
        let questionsViewController = QuestionsTableViewController.instantiate()
        questionsViewController.navigationItem.title = "Questions"
        
        // 2. Create View Model
        let questionsViewModel = QuestionsViewModel(productId: productId)
        questionsViewModel.coordinator = self
        questionsViewModel.viewController = questionsViewController
        
        // 3. Assign and navigate
        questionsViewController.viewModel = questionsViewModel
        self.navigationController.pushViewController(questionsViewController, animated: true)
    }
}
