//
//  ConversationsAPIListViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

protocol ConversationsAPIListViewControllerDelegate: class {
    
}

class ConversationsAPIListViewController: UIViewController, Storyboarded {

    // MARK:- Variables
    var viewModel: ConversationsAPIListViewModelDelegate?
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel?.getData()
    }
    

}

extension ConversationsAPIListViewController: ConversationsAPIListViewControllerDelegate {
    
}
