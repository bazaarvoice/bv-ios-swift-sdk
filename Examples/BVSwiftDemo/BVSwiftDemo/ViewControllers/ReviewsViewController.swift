//
//  ReviewsViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewsViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var productDetailsHeaderView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var reviewHighlightsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
