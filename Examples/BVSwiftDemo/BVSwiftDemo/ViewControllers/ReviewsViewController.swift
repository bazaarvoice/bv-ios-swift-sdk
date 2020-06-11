//
//  ReviewsViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol ReviewsViewControllerDelegate: class {
    
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
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var reviewHighlightsTableView: UITableView!
    
    // MARK:- Constants
    private static let REVIEW_CELL_IDENTIFIER: String = "ReviewTableViewCell"
    private static let REVIEW_HIGHLIGHTS_HEADER_CELL_IDENTIFIER: String = "ReviewHighlightsHeaderTableViewCell"
    private static let REVIEW_HIGHLIGHTS_CELL_IDENTIFIER: String = "ReviewHighLightsTableViewCell"
    private var reviewHighlightsHeaderModelArray: [ReviewHighlightsHeaderModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

// MARK:- UITableViewDataSource methods
extension ReviewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1//return self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2//return self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.reviewHighlightsTableView {
            
            if indexPath.section == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_HIGHLIGHTS_HEADER_CELL_IDENTIFIER) as! ReviewHighlightsHeaderTableViewCell
                cell.lbl_Title.text = "HeaderTableViewCell"
                return cell
                
            }
                
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_HIGHLIGHTS_CELL_IDENTIFIER) as! ReviewHighLightsTableViewCell
                cell.lbl_Title.text = "TableViewCell"
                return cell
                
            }
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsViewController.REVIEW_CELL_IDENTIFIER) as! ReviewTableViewCell
            
            return cell
        }
    }
    
}

extension ReviewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    
}
