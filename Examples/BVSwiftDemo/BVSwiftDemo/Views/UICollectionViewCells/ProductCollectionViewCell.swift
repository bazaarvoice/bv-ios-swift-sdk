//
//  ProductCollectionViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 04/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift
import HCSStarRatingView
import SDWebImage
import FontAwesomeKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_StarRating: HCSStarRatingView!
    @IBOutlet weak var imageView_Product: UIImageView!
    @IBOutlet weak var label_ProductName: UILabel!
    @IBOutlet weak var label_ProductPrice: UILabel!
    
    func setRecommendationProductDetails(recommendationProduct: BVRecommendationsProduct) {
        self.label_ProductName.text = recommendationProduct.productId?.capitalized
        self.view_StarRating.value = CGFloat(recommendationProduct.averageRating ?? 0)
        self.label_ProductPrice.text = ""
        self.imageView_Product.image = nil
        
        if let imageUrl = recommendationProduct.imageURL {
            
            self.imageView_Product.sd_setImage(with: imageUrl) { [weak self] (image, error, cacheType, url) in
                
                guard let strongSelf = self else { return }
                
                guard let _ = error else { return }
                strongSelf.imageView_Product.image = FAKFontAwesome.photoIcon(withSize: 100.0)?
                    .image(with: CGSize(width: strongSelf.imageView_Product.frame.size.width,
                                        height: strongSelf.imageView_Product.frame.size.height))
                strongSelf.imageView_Product.image?.withTintColor(UIColor.bazaarvoiceNavy)
            }
        }
        
    }
    
}
