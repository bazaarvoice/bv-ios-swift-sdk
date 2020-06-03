//
//  ProductDetailPageCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 03/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class ProductDisplayPageCell: UITableViewCell {

    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
