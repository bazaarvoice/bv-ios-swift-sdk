//
//  AuthorViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 16/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController {
    
    @IBOutlet weak var imageView_UserProfile: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserLocation: UILabel!
    @IBOutlet weak var lbl_UserBadges: UILabel!
    
    @IBOutlet weak var segmentedControl_UGCType: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
