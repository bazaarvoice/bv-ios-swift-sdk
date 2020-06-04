//
//  ProductDisplayPageCurationsCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 04/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class ProductDisplayPageCurationsCell: UITableViewCell {

    @IBOutlet weak var curationsCarousel: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
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

extension ProductDisplayPageCurationsCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurationsCollectionViewCell", for: indexPath) as? CurationsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
