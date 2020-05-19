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
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    // MARK:- Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = ViewController.instantiate()
        self.navigationController.pushViewController(mainViewController, animated: true)
    }
}
