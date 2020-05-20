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

    // MARK:- IBOutlets
    @IBOutlet weak var conversationsAPIListTableView: UITableView!
    
    // MARK:- Constants
    private static let CELL_IDENTIFIER = "ConversationsAPICell"
    
    // MARK:- Variables
    var viewModel: ConversationsAPIListViewModelDelegate!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

// MARK:- UITableViewDataSource methods
extension ConversationsAPIListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsAPIListViewController.CELL_IDENTIFIER) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = self.viewModel.titleForRowAtIndexPath(indexPath)
        return cell
    }
}

// MARK:- ConversationsAPIListViewControllerDelegate methods
extension ConversationsAPIListViewController: ConversationsAPIListViewControllerDelegate {
    
}
