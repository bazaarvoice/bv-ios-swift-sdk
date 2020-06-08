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
    
    enum ModuleNavigation: AppNavigator {
        case conversations
        case curations
        case recommendations
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
        
        guard let navigationScene = scene as? BVModule else { return }
        
        switch navigationScene {
            
        case .conversations:
            self.showConversationsModule()
            
        case .curations:
            self.showCurationsModule()
            
        case .recommendations:
            self.showRecommendationsModule()
        }
        
    }
    
    // MARK:- Private methods
    private func showConversationsModule() {
        let child = ConversationsCoordinator(navigationController: self.navigationController)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    private func showCurationsModule() {
        
    }
    
    private func showRecommendationsModule() {
        
    }
}
