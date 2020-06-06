//
//  ProductRecommendationsCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 05/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class ProductDetailRecommendationsTableViewCell: UITableViewCell {

    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    var numberOfRecommendations: (() -> (Int))?
    var recommendationAtIndexPath: ((IndexPath) -> (BVRecommendationsProduct?))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.recommendationsCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProductDetailRecommendationsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        guard let recommendation = self.recommendationAtIndexPath?(indexPath) else { return UICollectionViewCell() }

        cell.label_ProductName.text = recommendation.productId
        cell.label_ProductPrice.text = ""
        cell.imageView_Product.sd_setImage(with: recommendation.imageURL)
        cell.view_StarRating.value = CGFloat(recommendation.averageRating ?? 0.0)
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfRecommendations?() ?? 0
    }
}
