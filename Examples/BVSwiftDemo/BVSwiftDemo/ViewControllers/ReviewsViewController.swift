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

protocol ReviewsViewControllerDelegate: AnyObject {
    
    func reloadData()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
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

    // MARK:- Constants
    private static let REVIEW_HIGHLIGHTS_HEADER_CELL_IDENTIFIER: String = "ReviewHighlightsHeaderTableViewCell"
    private static let REVIEW_HIGHLIGHTS_CELL_IDENTIFIER: String = "ReviewHighLightsTableViewCell"
    private static let REVIEW_HIGHLIGHTS_SECTIONS_TOGGLE_IDENTIFIER: String = "ReviewsSectionsToogleTableViewCell"
    private static let REVIEW_CELL_IDENTIFIER: String = "ReviewTableViewCell"
		
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
}

// MARK:- UITableViewDataSource methods
extension ReviewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.viewModel.reviewTableSections[section] {
        case .features, .summary, .pros, .cons, .positiveQuotes, .negativeQuotes, .featureQuotes, .quotes, .reviews:
            return 40
        case .actionButtons:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_HIGHLIGHTS_HEADER_CELL_IDENTIFIER) as! ReviewHighlightsHeaderTableViewCell
        var image: String = ""
        if self.viewModel.reviewTableSections[section] == .pros {
            image = "plus.circle"
        } else if self.viewModel.reviewTableSections[section] == .cons {
            image = "minus.circle"
        }
        cell.setReviewHighlightsData(title: self.viewModel.headerTitleForSection(section), image: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = self.viewModel.reviewTableSections[indexPath.section]
        switch sectionType {
            
        case .features, .summary, .pros, .cons, .positiveQuotes, .negativeQuotes, .featureQuotes, .quotes:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_HIGHLIGHTS_CELL_IDENTIFIER) as! ReviewHighLightsTableViewCell
            let displayText = self.viewModel.reviewHighlightsTitleForIndexPath(indexPath)
            cell.setReviewHighlightsTitle(title: displayText)
            if sectionType == .pros {
                cell.titleLabel.textColor = UIColor.systemGreen
                cell.setBgViewBorder(color: UIColor.systemGreen.withAlphaComponent(0.5))
            } else if sectionType == .cons {
                cell.titleLabel.textColor = UIColor.systemRed
                cell.setBgViewBorder(color: UIColor.systemRed.withAlphaComponent(0.5))
            } else {
                cell.titleLabel.textColor = UIColor.systemGray
                cell.setBgViewBorder(color: UIColor.systemGray.withAlphaComponent(0.5))
            }
            return cell

        case .actionButtons:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_HIGHLIGHTS_SECTIONS_TOGGLE_IDENTIFIER) as! ReviewsSectionsToogleTableViewCell
            cell.setButtonsTitle(sortButtonTitle: self.viewModel.sortButtonTitle)
            cell.delegate = self
            return cell

        case .reviews:
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
        self.viewModel.didSelectRowAt(indexPath)
    }
}

extension ReviewsViewController: ReviewsViewControllerDelegate {

    func reloadData() {
        DispatchQueue.main.async {
            self.reviewTableView.reloadData()
        }
    }
    
    func showLoadingIndicator() {
        self.showSpinner()
    }
    
    func hideLoadingIndicator() {
        self.removeSpinner()
    }
}

extension ReviewsViewController: ReviewsSectionsToogleTableViewCellDelegate {
    func didToggleReviewHighlights(isOn: Bool) {
        self.viewModel.toggleReviewHighlights(isOn: isOn)
        self.reviewTableView.reloadData()
    }
    
    func didSortReviews() {
        let actionController = BVSwiftDemoActionController()
        
        ReviewsViewModel.FilterOptions.allCases.forEach { (filterOption) in
            
            actionController.addAction(Action(filterOption.rawValue, style: .default, handler: { action in
                self.viewModel.didChangeFilterOption(ReviewsViewModel.FilterOptions.init(rawValue: action.data!)!)
                
            }))
        }
        
        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
        
        self.viewModel.sortButtonTapped(actionController)
        
    }
}

