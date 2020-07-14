//
//  AskAQuestionViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 14/07/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol AskAQuestionViewControllerDelegate: class {
    
}

class AskAQuestionViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: AskAQuestionViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStarRatingView: HCSStarRatingView!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(AskAQuestionViewController.submitQuestionTapped))
    }
    
    @objc func submitQuestionTapped() {
        self.viewModel.submitQuestionTapped()
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

// MARK:- AskAQuestionViewControllerDelegate methods
extension AskAQuestionViewController: AskAQuestionViewControllerDelegate {
    
}
