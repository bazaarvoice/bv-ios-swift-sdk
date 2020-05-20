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
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    // MARK:- Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO:- Need to create child coordinator for conversations module
//        let mainViewController = HomeViewController.instantiate()
//        mainViewController.navigationItem.titleView = HomeViewController.createTitleLabel()
//        self.navigationController.pushViewController(mainViewController, animated: true)
        
        // 1. Create View Controller
        let mainViewController = ConversationsAPIListViewController.instantiate()
        mainViewController.navigationItem.titleView = HomeViewController.createTitleLabel()
        
        // 2. Create View Model
        let viewModel = ConversationsAPIListViewModel()
        viewModel.viewController = mainViewController
        viewModel.coordinator = self
        
        // 3. Assign View Model and Push View Controller
        mainViewController.viewModel = viewModel
        self.navigationController.pushViewController(mainViewController, animated: true)
        
    }
    
    func navigateTo(_ scene: AppNavigator) {
        
        guard let navigationScene = scene as? ModuleNavigation else { return }
        
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
        
    }
    
    private func showCurationsModule() {
        
    }
    
    private func showRecommendationsModule() {
        
    }
}
