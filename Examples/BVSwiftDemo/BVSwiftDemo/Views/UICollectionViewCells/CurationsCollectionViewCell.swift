//
//  CurationsCollectionViewCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 04/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class CurationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var socialImageView: UIImageView!
    @IBOutlet weak var sourceIconImageView: UIImageView!
    
    func setDetails(socialImageURL: URL?, sourceImage: String?) {
        
        // set social image
        if let imageUrl = socialImageURL {
            
            self.socialImageView.sd_setImage(with: imageUrl) { [weak self] (image, error, cacheType, url) in
                
                guard let strongSelf = self else { return }
                
                guard let _ = error else { return }
                strongSelf.socialImageView.image = #imageLiteral(resourceName: "placeholder")
            }
        }
        else {
            self.socialImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        
        // set channel image
        if let channel = sourceImage {
            self.sourceIconImageView.image = UIImage(named: channel)
        }
    }
}
