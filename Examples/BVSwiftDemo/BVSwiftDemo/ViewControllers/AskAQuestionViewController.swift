//
//  AskAQuestionViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 14/07/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import FontAwesomeKit
import SDForms

protocol AskAQuestionViewControllerDelegate: class {
}

class AskAQuestionViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: AskAQuestionViewModelDelegate!
    private var form: SDForm?
    
    // MARK:- IBOutlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStarRatingView: HCSStarRatingView!
    @IBOutlet weak var askAQuestionTableView: UITableView!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(AskAQuestionViewController.submitQuestionTapped))
        self.updateProductDetails()
        self.configureForm()
        
        self.askAQuestionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        self.view.backgroundColor = UIColor.appBackground
        self.askAQuestionTableView.backgroundColor = UIColor.white
    }
    
    @objc func submitQuestionTapped() {
        self.viewModel.submitQuestionTapped()
    }
    
    private func updateProductDetails() {
        self.productNameLabel.text = self.viewModel.productName
        
        self.productStarRatingView.value = CGFloat(self.viewModel.productRating ?? 0.0)
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK:- SDFormDataSource and SDFormDelegate methods
extension AskAQuestionViewController: SDFormDataSource, SDFormDelegate {
    
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
    
    func viewController(for form: SDForm!) -> UIViewController! {
        return self
    }
}

// MARK:- AskAQuestionViewControllerDelegate methods
extension AskAQuestionViewController: AskAQuestionViewControllerDelegate {
    
    func configureForm() {
        self.form = SDForm(tableView: self.askAQuestionTableView)
        self.form?.delegate = self
        self.form?.dataSource = self
    }
}
