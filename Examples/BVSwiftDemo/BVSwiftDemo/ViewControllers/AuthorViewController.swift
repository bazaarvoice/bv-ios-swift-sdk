//
//  AuthorViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 16/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

protocol AuthorViewControllerDelegate: class {
    
    func updateAuthorDetails()
    
    func reloadData()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
}

class AuthorViewController: UIViewController, ViewControllerType {
    
    // MARK: Variables
    var viewModel: AuthorViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var imageView_UserProfile: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserLocation: UILabel!
    @IBOutlet weak var lbl_UserBadges: UILabel!
    
    @IBOutlet weak var segmentedControl_UGCType: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Constants
    private static let REVIEW_CELL_IDENTIFIER: String = "ReviewTableViewCell"
    private static let QUESTION_CELL_IDENTIFIER: String = "QuestionAnswerTableViewCell"
    private static let ANSWER_CELL_IDENTIFIER = "AnswerTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewModel.fetchAuthorProfile()
        
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
}

extension AuthorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedSegment = AuthorViewModel.SegmentControllerTypes.init(rawValue: self.segmentedControl_UGCType.selectedSegmentIndex) else { return 0 }
        
        switch selectedSegment  {
            
        case .Reviews:
            
            return self.viewModel.numberOfRowsForReview
            
        case .Questions:
            
            return self.viewModel.numberOfRowsForQuestion
            
        case .Answers:
            
            return self.viewModel.numberOfRowsForAnswer
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let selectedSegment = AuthorViewModel.SegmentControllerTypes.init(rawValue: self.segmentedControl_UGCType.selectedSegmentIndex) else { return UITableViewCell() }
        
        switch selectedSegment  {
            
        case .Reviews:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthorViewController.REVIEW_CELL_IDENTIFIER) as! ReviewTableViewCell
            
            if let review = self.viewModel.reviewForIndexPath(indexPath) {
                
                cell.setReview(review: review)
                
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        case .Questions:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthorViewController.QUESTION_CELL_IDENTIFIER) as! QuestionAnswerTableViewCell
            
            cell.selectionStyle = .none
            
            if let question = self.viewModel.questionForIndexPath(indexPath) {
                
                cell.setQuestionDetails(question: question, isOnlyQuestion: true)
            }
            
            return cell
            
        case .Answers:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthorViewController.ANSWER_CELL_IDENTIFIER) as! AnswerTableViewCell
            
            cell.selectionStyle = .none
            
            if let anwser = self.viewModel.answerForIndexPath(indexPath) {
                
                cell.setAnswerDetails(answer: anwser)
            }
            
            return cell
            
        }
    }
}

extension AuthorViewController: AuthorViewControllerDelegate {
    
    func updateAuthorDetails() {
        
        if let userProfileImageURL = self.viewModel.userProfileImageURL {
            self.imageView_UserProfile.sd_setImage(with: userProfileImageURL, completed: nil)
        }
        
        self.lbl_UserName.text = self.viewModel.userName.capitalized
        
        self.lbl_UserLocation.text = self.viewModel.userLoaction.capitalized
        
        self.lbl_UserBadges.text = self.viewModel.userBadges.capitalized
        
        self.segmentedControl_UGCType.setTitle(self.viewModel.reviewButtonText, forSegmentAt: AuthorViewModel.SegmentControllerTypes.Reviews.rawValue)
        
        self.segmentedControl_UGCType.setTitle(self.viewModel.questionButtonText, forSegmentAt: AuthorViewModel.SegmentControllerTypes.Questions.rawValue)
        
        self.segmentedControl_UGCType.setTitle(self.viewModel.answerButtonText, forSegmentAt: AuthorViewModel.SegmentControllerTypes.Answers.rawValue)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func showLoadingIndicator() {
        self.showSpinner()
    }
    
    func hideLoadingIndicator() {
        self.removeSpinner()
    }
}
