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

class ConversationsAPIListViewController: UIViewController, ViewControllerType {

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
        self.conversationsAPIListTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    

}

// MARK:- UITableViewDataSource methods
extension ConversationsAPIListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsAPIListViewController.CELL_IDENTIFIER) else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.text = self.viewModel.titleForRowAtIndexPath(indexPath)
        return cell
    }
}

// MARK:- UITableViewDelegate methods
extension ConversationsAPIListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.didSelectRowAtIndexPath(indexPath)
    }
}

// MARK:- ConversationsAPIListViewControllerDelegate methods
extension ConversationsAPIListViewController: ConversationsAPIListViewControllerDelegate {
    
}
