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
    
    func reloadTableView()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
}

class WriteReviewViewController: UIViewController, ViewControllerType {
    
    // MARK:- Variables
    var viewModel: WriteReviewViewModelDelegate!
    private var productReviewData: BVMultiProductFormData?
    var formFields : [SDFormField] = []
    var paramDict: NSMutableDictionary = [:]
    var sectionTitles : [String] = []
    var form : SDForm?
    
    // MARK:- IBOutlets
    @IBOutlet weak var productDetailsHeaderView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var WriteReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.configureForm()
    }
    
    func configureForm() {
        self.form = SDForm(tableView: self.WriteReviewTableView)
        self.form?.delegate = self
        self.form?.dataSource = self
    }
    
}

extension WriteReviewViewController: WriteReviewViewControllerDelegate {
    
    func reloadTableView() {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
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
