//
//  ReviewsViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import XLActionController
import HCSStarRatingView
import FontAwesomeKit

protocol ReviewsViewControllerDelegate: class {
    
    func reloadData()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func updateSortButtonTitle(title: String)
}

class ReviewsViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: ReviewsViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var productDetailsHeaderView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var reviewHighlightsTableView: UITableView!
    @IBOutlet weak var reviewHighlightsTableHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var sortButton: UIButton!
    
    // MARK:- Constants
    private static let REVIEW_CELL_IDENTIFIER: String = "ReviewTableViewCell"
    private static let REVIEW_HIGHLIGHTS_HEADER_CELL_IDENTIFIER: String = "ReviewHighlightsHeaderTableViewCell"
    private static let REVIEW_HIGHLIGHTS_CELL_IDENTIFIER: String = "ReviewHighLightsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavigationBarButtonNames.write_a_Review,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(ReviewsViewController.writeReviewTapped))
        self.viewModel.fetchReviews()
        
        self.updateProductDetails()
    }
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
        
        let actionController = BVSwiftDemoActionController()

        actionController.addAction(Action(ReviewsViewModel.FilterOptions.mostRecent.title, style: .default, handler: { action in
            self.viewModel.didChangeFilterOption(ReviewsViewModel.FilterOptions.mostRecent)
        }))
        
        actionController.addAction(Action(ReviewsViewModel.FilterOptions.lowestRating.title, style: .default, handler: { action in
            self.viewModel.didChangeFilterOption(ReviewsViewModel.FilterOptions.lowestRating)
        }))
        
        actionController.addAction(Action(ReviewsViewModel.FilterOptions.highestRating.title, style: .default, handler: { action in
            self.viewModel.didChangeFilterOption(ReviewsViewModel.FilterOptions.highestRating)
        }))
        
        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))

        present(actionController, animated: true, completion: nil)
        
    }
    
    func updateProductDetails() {
        
        self.productNameLabel.text = self.viewModel.productName
        
        self.productRatingView.value = CGFloat(self.viewModel.productRating ?? 0.0)
        
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
    
    @objc func writeReviewTapped() {
        self.viewModel.writeReviewTapped()
    }
    
    private func updateReviewHightlightsTableViewHeightConstraints(indexPath: IndexPath) {
        
        if self.viewModel.isReviewHighlightsExpanded {
            self.reviewHighlightsTableHeightConstraints.constant = CGFloat((100 + (self.viewModel.reviewHighlightsCountForIndexPath(indexPath) * 40)))
        }
        else {
            self.reviewHighlightsTableHeightConstraints.constant = 100
        }
    }
}

// MARK:- UITableViewDataSource methods
extension ReviewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.reviewTableView {
            return self.viewModel.numberOfSectionsForReviews
        }
        else {
            return self.viewModel.numberOfSectionsForReviewHighlights
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.reviewTableView {
            return self.viewModel.numberOfRowsForReview
        }
        else {
            return self.viewModel.numberOfRowsForReviewHighlights(section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.reviewHighlightsTableView {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_HIGHLIGHTS_HEADER_CELL_IDENTIFIER) as! ReviewHighlightsHeaderTableViewCell
                
                cell.selectionStyle = .none
                cell.setReviewHighlightsData(title: self.viewModel.reviewHighlightsHeaderTitleForIndexPath(indexPath),
                                             count: self.viewModel.reviewHighlightsCountForIndexPath(indexPath))
                
                return cell
                
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_HIGHLIGHTS_CELL_IDENTIFIER) as! ReviewHighLightsTableViewCell
                
                cell.selectionStyle = .none
                cell.setReviewHighlightsTitle(title: self.viewModel.reviewHighlightsTitleForIndexPath(indexPath))
                return cell
                
            }
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_CELL_IDENTIFIER) as! ReviewTableViewCell
            
            cell.selectionStyle = .none
            
            if let review = self.viewModel.reviewForIndexPath(indexPath) {
                
                cell.setReview(review: review)
            }
            
            cell.onAuthorNickNameTapped = { authorId in
                self.viewModel.gotoAuthorProfile(authorId: authorId)
            }
            
            return cell
        }
    }
    
}

extension ReviewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.reviewHighlightsTableView && indexPath.row == 0 {
            
            self.viewModel.didSelectRowAt(indexPath)
            
            self.updateReviewHightlightsTableViewHeightConstraints(indexPath: indexPath)
            self.reviewHighlightsTableView.reloadData()
        }
    }
}

extension ReviewsViewController: ReviewsViewControllerDelegate {

    func reloadData() {
        self.reviewTableView.reloadData()
        self.reviewHighlightsTableView.reloadData()
    }
    
    func showLoadingIndicator() {
        self.showSpinner()
    }
    
    func hideLoadingIndicator() {
        self.removeSpinner()
    }
    
    func updateSortButtonTitle(title: String) {
        self.sortButton.setTitle(title, for: UIControl.State())
    }
}
