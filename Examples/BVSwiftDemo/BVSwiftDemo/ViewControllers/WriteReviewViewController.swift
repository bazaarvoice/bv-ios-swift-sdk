//
//  WriteReviewViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 14/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol WriteReviewViewControllerDelegate: class {
    
    func reloadTableView()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
}

class WriteReviewViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: WriteReviewViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var productDetailsHeaderView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var WriteReviewTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
