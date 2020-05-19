//
//  Coordinator.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    
    var childCoordinators: [Coordinator] { get set }
    
    var navigationController: UINavigationController { get set }
    
    func start()
    
    func navigateTo(_ scene: AppNavigator)
}

protocol AppNavigator {
    
}
