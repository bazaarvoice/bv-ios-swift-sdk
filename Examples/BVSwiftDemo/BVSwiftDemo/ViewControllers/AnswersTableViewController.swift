//
//  AnswersTableViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 09/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import FontAwesomeKit

protocol AnswersViewControllerDelegate: class {
    
}

class AnswersTableViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: AnswersViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var questionTtileLabel: UILabel!
    @IBOutlet weak var questionMetaDataLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    
    // MARK:- Constants
    private static let CELL_IDENTIFIER = "AnswerTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.updateProductDetails()
        self.updateQuestionDetails()
    }
    
    
    private func updateProductDetails() {
        
        self.productNameLabel.text = self.viewModel.productName
        
        if let imageURL = self.viewModel.imageURL {
            
            self.productImageView.sd_setImage(with: imageURL) { [weak self] (image, error, cacheType, url) in
                
                guard let strongSelf = self else { return }
                
                guard let _ = error else { return }
                
                strongSelf.productImageView.image = FAKFontAwesome.photoIcon(withSize: 70.0)?
                    .image(with: CGSize(width: strongSelf.productImageView.frame.size.width + 20,
                                        height: strongSelf.productImageView.frame.size.height + 20))
                    .withTintColor(UIColor.bazaarvoiceNavy)
            }
        }
    }
    
    private func updateQuestionDetails() {
        
        questionTtileLabel.text = self.viewModel.questionSummary
                
        questionMetaDataLabel.text = self.viewModel.questionMetaData
    }
    
}

// MARK:- UITableViewDataSource methods
extension AnswersTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswersTableViewController.CELL_IDENTIFIER) as? AnswerTableViewCell else { return UITableViewCell() }
        
        if let answer = self.viewModel.answerForRowAtIndexPath(indexPath) {
            cell.setAnswerDetails(answer: answer)
        }
        
        cell.onAuthorNickNameTapped = { authorId in
            self.viewModel.gotoAuthorProfile(authorId: authorId)
        }
        
        return cell
    }
}

// MARK:- AnswersViewControllerDelegate methods
extension AnswersTableViewController: AnswersViewControllerDelegate {
    
}
