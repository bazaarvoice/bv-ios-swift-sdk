//
//  QuestionsTableViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 27/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

protocol QuestionsTableViewControllerDelegate: class {
    
}

class QuestionsTableViewController: UIViewController, ViewControllerType {

    // MARK:- Variables
    var viewModel: QuestionsViewModelDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewModel.fetchQuestions()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- ConversationsAPIListViewControllerDelegate methods
extension QuestionsTableViewController: QuestionsTableViewControllerDelegate {
    
}
