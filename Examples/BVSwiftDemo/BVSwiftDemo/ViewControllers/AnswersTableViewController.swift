//
//  AnswersTableViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 09/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol AnswersViewControllerDelegate: class {

}

class AnswersTableViewController: UIViewController, ViewControllerType {

    // MARK:- Variables
    var viewModel: AnswersViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- AnswersViewControllerDelegate methods
extension AnswersTableViewController: AnswersViewControllerDelegate {

}
