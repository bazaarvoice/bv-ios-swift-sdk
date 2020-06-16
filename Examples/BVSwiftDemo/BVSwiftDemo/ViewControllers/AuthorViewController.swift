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
    
}

extension AuthorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.viewModel.numberOfRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AuthorViewController.REVIEW_CELL_IDENTIFIER) as! ReviewTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: AuthorViewController.QUESTION_CELL_IDENTIFIER) as! QuestionAnswerTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: AuthorViewController.ANSWER_CELL_IDENTIFIER) as! AnswerTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
        
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
