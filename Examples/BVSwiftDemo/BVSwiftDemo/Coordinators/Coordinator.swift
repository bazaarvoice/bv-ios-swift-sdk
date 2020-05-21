//
//  Coordinator.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit


protocol AppNavigator {
    
}


class Coordinator: NSObject, UINavigationControllerDelegate {
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.delegate = self
    }
    
    func navigateTo(_ scene: AppNavigator) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            // Its a push; do nothing
            return
        }

        // Its a pop. Check if it is the coordinator's first view controller and call parent coordinators childDidFinish() method.
        if fromViewController is ConversationsAPIListViewController {
            self.parentCoordinator?.childDidFinish(self)
        }

    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in self.childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                self.navigationController.delegate = self
                break
            }
        }
    }
}
