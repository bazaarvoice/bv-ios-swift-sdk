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
        if let imageURL = socialImageURL {
            self.socialImageView.sd_setImage(with: imageURL)
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
