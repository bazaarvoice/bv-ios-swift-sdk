//
//  ViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 19/05/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ViewControllerType {
    
    // MARK:- IBOutlets
    @IBOutlet weak var bvModulesTableView: UITableView!
    
    // MARK:- Constants
    private static let CELL_IDENTIFIER = "BVModuleListCell"
    
    // MARK:- Variables
    var viewModel: HomeViewModelDelegate!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bvModulesTableView.tableFooterView = UIView()
    }
    
    class func createTitleLabel() -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 44))
        
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34)
        return titleLabel
    }
    
    @IBAction func showNextTapped(_ sender: Any) {
       // self.viewModel.didTapShowNextButton()
    }
    
    
}

// Mark:- HomeViewControllerDatasource methods
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.CELL_IDENTIFIER) else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.text = self.viewModel.titleForRowAtIndexPath(indexPath)

        return cell
    }
}

// MARK:- HomeViewControllerDelegate methods
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.viewModel.didSelectRowAt(indexPath: indexPath)
    }
}

