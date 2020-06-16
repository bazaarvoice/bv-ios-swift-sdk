//
//  QuestionsTableViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 27/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import FontAwesomeKit

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
    
    // MARK:- IBOutlets
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStarRatingView: HCSStarRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask a question",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(QuestionsTableViewController.askQuestionTapped))
        
        self.updateProductDetails()
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
    
    func updateProductDetails() {
        self.productNameLabel.text = self.viewModel.productName
        
        if let imageURL = self.viewModel.productImageURL {
            
            self.productImageView.sd_setImage(with: imageURL) { [weak self] (image, error, cacheType, url) in
                
                guard let strongSelf = self else { return }
                
                guard let _ = error else { return }
                
                strongSelf.productImageView.image = FAKFontAwesome.photoIcon(withSize: 70.0)?
                    .image(with: CGSize(width: strongSelf.productImageView.frame.size.width + 20,
                                        height: strongSelf.productImageView.frame.size.height + 20))
                    .withTintColor(UIColor.bazaarvoiceNavy)
            }
        }
        else {
            self.productImageView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
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
            cell.setQuestionDetails(question: question, isOnlyQuestion: false)
        }
        
        cell.onReadAnswersTapped = { question in
            self.viewModel.readAnswersTapped(question: question)
        }
        
        return cell
    }
    
}
