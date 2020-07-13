//
//  HomeAdvertisementCollectionViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeAdvertisementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nativeContentAdView : GADUnifiedNativeAdView!
    
    var nativeContentAd : GADUnifiedNativeAd? {
        didSet {
            let headlineLabel = nativeContentAdView.headlineView as! UILabel
            let bodyLabel = nativeContentAdView.bodyView as! UILabel
            let imageView = nativeContentAdView.imageView as! UIImageView
            
            headlineLabel.text = nativeContentAd?.headline
            bodyLabel.text = nativeContentAd?.body
            let image = nativeContentAd?.images![0] as! GADNativeAdImage
            imageView.image = image.image
            
            nativeContentAdView.nativeAd = nativeContentAd
        }
    }
}
