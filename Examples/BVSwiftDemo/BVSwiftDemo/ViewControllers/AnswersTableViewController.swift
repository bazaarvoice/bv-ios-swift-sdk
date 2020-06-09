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
                
                strongSelf.productImageView.image = FAKFontAwesome.photoIcon(withSize: 100.0)?
                    .image(with: CGSize(width: strongSelf.productImageView.frame.size.width + 20,
                                        height: strongSelf.productImageView.frame.size.height + 20))
            }
        }
    }
    
    private func updateQuestionDetails() {
        
        questionTtileLabel.text = self.viewModel.questionSummary
        
        questionTextLabel.text = self.viewModel.questionDetails
        
        questionMetaDataLabel.text = self.viewModel.questionMetaData
    }
    
}

// MARK:- AnswersViewControllerDelegate methods
extension AnswersTableViewController: AnswersViewControllerDelegate {
    
}
