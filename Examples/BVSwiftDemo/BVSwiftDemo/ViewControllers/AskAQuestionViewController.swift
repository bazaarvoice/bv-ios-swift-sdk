//
//  AskAQuestionViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 14/07/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

protocol AskAQuestionViewControllerDelegate: class {
  
}

class AskAQuestionViewController: UIViewController, ViewControllerType {
  
  // MARK:- Variables
  var viewModel: AskAQuestionViewModelDelegate!

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

// MARK:- AskAQuestionViewControllerDelegate methods
extension AskAQuestionViewController: AskAQuestionViewControllerDelegate {
  
}
