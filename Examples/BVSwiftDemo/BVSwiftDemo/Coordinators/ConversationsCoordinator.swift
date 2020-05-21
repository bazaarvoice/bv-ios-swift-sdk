//
//  ConversationsCoordinator.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

class ConversationsCoordinator: Coordinator {
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        
        super.start()
    
        // 1. Create View Controller
        let mainViewController = ConversationsAPIListViewController.instantiate()
        
        // 2. Create View Model
        let viewModel = ConversationsAPIListViewModel()
        viewModel.viewController = mainViewController
        viewModel.coordinator = self
        
        // 3. Assign View Model and Push View Controller
        mainViewController.viewModel = viewModel
        self.navigationController.pushViewController(mainViewController, animated: true)
    }
    
    override func navigateTo(_ scene: AppNavigator) {
        
    }
}
