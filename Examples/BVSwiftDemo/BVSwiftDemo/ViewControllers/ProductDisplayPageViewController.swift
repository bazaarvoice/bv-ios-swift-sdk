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
    
}

class ProductDisplayPageViewController: UIViewController , ViewControllerType {

    var viewModel: ProductDisplayPageViewModelDelegate!
    
    // MARK:- IBOutlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRatingView: HCSStarRatingView!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel.fetchProductDisplayPageDetails()
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

// MARK:- ProductDisplayPageViewControllerDelegate methods
extension ProductDisplayPageViewController: ProductDisplayPageViewControllerDelegate {
    
    func updateProductDetails(name: String,
                              imageURL: URL) {
        self.productNameLabel.text = name
        self.productImageView.sd_setImage(with: imageURL) { [weak self] (image, error, cacheType, url) in
            
            guard let strongSelf = self else { return }
            
            guard let _ = error else { return }
            
            strongSelf.productImageView.image = FAKFontAwesome.photoIcon(withSize: 100.0)?
                .image(with: CGSize(width: strongSelf.productImageView.frame.size.width + 20,
                                    height: strongSelf.productImageView.frame.size.height + 20))
        }
    }
}
