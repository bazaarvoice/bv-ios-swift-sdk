//
//  ProductCollectionViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 04/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ProductCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_StarRating: HCSStarRatingView!
    @IBOutlet weak var imageView_Product: UIImageView!
    @IBOutlet weak var label_ProductName: UILabel!
    @IBOutlet weak var label_ProductPrice: UILabel!
    
}
