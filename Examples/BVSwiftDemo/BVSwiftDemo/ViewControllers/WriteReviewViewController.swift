//
//  WriteReviewViewController.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 14/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import BVSwift
import FontAwesomeKit
import SDForms

protocol WriteReviewViewControllerDelegate: class {
    
}

class WriteReviewViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: WriteReviewViewModelDelegate!
    private var form: SDForm?
    
    // MARK:- IBOutlets
    @IBOutlet weak var productDetailsHeaderView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var WriteReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(WriteReviewViewController.submitQuestionTapped))
        
        self.configureForm()
        self.updateProductDetails()
    }
    
    func configureForm() {
        self.form = SDForm(tableView: self.WriteReviewTableView)
        self.form?.delegate = self
        self.form?.dataSource = self
    }
    
    @objc func submitQuestionTapped() {
        self.viewModel.submitQuestionTapped()
    }
    
    private func updateProductDetails() {
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
    
}

extension WriteReviewViewController: WriteReviewViewControllerDelegate {
    
}

extension WriteReviewViewController: SDFormDataSource {
    
    func form(_ form: SDForm!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        let hv = view as! UITableViewHeaderFooterView
        let color = UIColor.white
        hv.tintColor = color
        hv.contentView.backgroundColor = color
        hv.textLabel?.textColor = UIColor.bazaarvoiceNavy
    }
    
    func numberOfSections(for form: SDForm!) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func form(_ form: SDForm!, numberOfFieldsInSection section: Int) -> Int {
        return self.viewModel.numberOfFieldsInSection(section)
    }
    
    func form(_ form: SDForm!, titleForHeaderInSection section: Int) -> String! {
        return self.viewModel.titleForHeaderInSection(section)
    }
    
    func form(_ form: SDForm!, fieldForRow row: Int, inSection section: Int) -> SDFormField! {
        return self.viewModel.formFieldForRow(row: row, inSection: section)
    }
    
}

extension WriteReviewViewController: SDFormDelegate {
    
    func viewController(for form: SDForm!) -> UIViewController! {
        return self
    }
}
