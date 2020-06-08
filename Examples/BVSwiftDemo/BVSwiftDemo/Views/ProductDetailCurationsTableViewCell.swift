//
//  ProductDisplayPageCurationsCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 04/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class ProductDetailCurationsTableViewCell: UITableViewCell {

    @IBOutlet weak var curationsCarousel: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var numberOfCurations: (() -> (Int))?
    var curationAtIndexPath: ((IndexPath) -> (BVCurationsFeedItem?))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.curationsCarousel.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ProductDetailCurationsTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItems = self.numberOfCurations?(), numberOfItems != 0 {
            self.errorLabel.isHidden = true
            return numberOfItems
        }
        else {
            self.errorLabel.isHidden = false
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurationsCollectionViewCell", for: indexPath) as? CurationsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let curationFeedItem = self.curationAtIndexPath?(indexPath) else {
            return UICollectionViewCell()
        }
        
        
        if let imageURL = self.curationAtIndexPath?(indexPath)?.photos?.first?.imageServiceURL?.value {
            cell.socialImageView.sd_setImage(with: imageURL)
        }
        else {
            cell.socialImageView.image = #imageLiteral(resourceName: "placeholder")
        }
       
        if let channel = curationFeedItem.channel {
            cell.sourceIconImageView.image = UIImage(named: channel)
        }
        
        return cell
    }
}
