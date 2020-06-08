//
//  ProductDisplayPageViewController.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 02/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import SDWebImage
import FontAwesomeKit

protocol ProductDisplayPageViewControllerDelegate: class {
    
    func updateProductDetails(name: String,
                              imageURL: URL)
    func reloadData()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
}

class ProductDisplayPageViewController: UIViewController , ViewControllerType {
    
    var viewModel: ProductDisplayPageViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var productDetailsHeaderView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    @IBOutlet weak var productDetailsTableView: UITableView!
    
    private static let PRODUCT_DETAIL_CELL_IDENTIFIER: String = "ProductDetailTableViewCell"
    private static let PRODUCT_DETAIL_CURATIONS_CELL_IDENTIFIER: String = "ProductDetailCurationsTableViewCell"
     private static let PRODUCT_DETAIL_RECOMMENDATIONS_CELL_IDENTIFIER: String = "ProductDetailRecommendationsTableViewCell"
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.productDetailsHeaderView.isHidden = true
        self.productDetailsTableView.isHidden = true
        
        self.viewModel.fetchProductDisplayPageData()
    }
    
    class func createTitleLabel() -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 44))
        
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 34)
        return titleLabel
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

// MARK:- UITableViewDataSource methods
extension ProductDisplayPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let rowType = self.viewModel.rowTypeAtIndexPath(indexPath) else {
            return UITableViewCell()
        }
        
        switch rowType {
            
        case .reviews, .questions, .curationsAddPhoto, .curationsPhotoMap:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductDisplayPageViewController.PRODUCT_DETAIL_CELL_IDENTIFIER) as! ProductDetailTableViewCell
            cell.setProductDetails(name: self.viewModel.titleForIndexPath(indexPath),
                                          icon: self.viewModel.iconForIndexPath(indexPath))
            return cell
            
        case .curations:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductDisplayPageViewController.PRODUCT_DETAIL_CURATIONS_CELL_IDENTIFIER) as! ProductDetailCurationsTableViewCell
            cell.numberOfCurations = {
                return self.viewModel.numberOfCurations
            }
            cell.curationsCarousel.reloadData()
            return cell
            
        case .recommendations:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductDisplayPageViewController.PRODUCT_DETAIL_RECOMMENDATIONS_CELL_IDENTIFIER) as! ProductDetailRecommendationsTableViewCell
            
            cell.numberOfRecommendations = {
                return self.viewModel.numberOfRecommendations
            }
            
            cell.recommendationAtIndexPath = { indexPath in
                return self.viewModel.recommendationAtIndexPath(indexPath)
            }
            
            cell.recommendationsCollectionView.reloadData()
            
            return cell
        }
    }
}

// MARK:- ProductDisplayPageViewControllerDelegate methods
extension ProductDisplayPageViewController: ProductDisplayPageViewControllerDelegate {
    
    func updateProductDetails(name: String,
                              imageURL: URL) {
        
        self.productDetailsHeaderView.isHidden = false
        
        self.productNameLabel.text = name
        self.productImageView.sd_setImage(with: imageURL) { [weak self] (image, error, cacheType, url) in
            
            guard let strongSelf = self else { return }
            
            guard let _ = error else { return }
            
            strongSelf.productImageView.image = FAKFontAwesome.photoIcon(withSize: 100.0)?
                .image(with: CGSize(width: strongSelf.productImageView.frame.size.width + 20,
                                    height: strongSelf.productImageView.frame.size.height + 20))
        }
    }
    
    func reloadData() {
        self.productDetailsTableView.isHidden = false
        self.productDetailsTableView.reloadData()
    }
    
    func showLoadingIndicator() {
        self.showSpinner()
    }
    
    func hideLoadingIndicator() {
        self.removeSpinner()
    }
    
}
