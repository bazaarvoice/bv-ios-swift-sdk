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
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
      //  self.navigationController.delegate = self
        
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
        
    }
}
