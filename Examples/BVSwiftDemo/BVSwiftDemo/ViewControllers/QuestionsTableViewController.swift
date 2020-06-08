//
//  QuestionsTableViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 27/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

protocol QuestionsTableViewControllerDelegate: class {
    func reloadTableView()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
}

class QuestionsTableViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: QuestionsViewModelDelegate!
    
    // MARK:- Constants
    private static let CELL_IDENTIFIER: String = "QuestionAnswerTableViewCell"
    
    @IBOutlet weak var questionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask a question",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(QuestionsTableViewController.askQuestionTapped))
        
        self.viewModel.fetchQuestions()
    }
    
    @objc func askQuestionTapped() {
        self.viewModel.askQuestionTapped()
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
    
    func showLoadingIndicator() {
        self.showSpinner()
    }
    
    func hideLoadingIndicator() {
        self.removeSpinner()
    }
    
    func reloadTableView() {
        self.questionsTableView.reloadData()
    }
}

// MARK:- UITableViewDataSource methods
extension QuestionsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionsTableViewController.CELL_IDENTIFIER) as? QuestionAnswerTableViewCell else { return UITableViewCell() }
        
        if let question = self.viewModel.questionForRowAtIndexPath(indexPath) {
            cell.setQuestionDetails(question: question)
        }
        
        return cell
    }
    
}
