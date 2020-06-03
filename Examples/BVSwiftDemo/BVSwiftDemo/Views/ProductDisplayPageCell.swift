//
//  ProductDetailPageCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 03/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import FontAwesomeKit

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
    
    func setProductDetails(name: String,
                           icon: ((_ size: CGFloat) -> FAKFontAwesome?)) {
        
        self.titleLabel.text = name
        self.leftIconImageView.image = self.getIconImage(icon)
    }
    
    func getIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?)) -> UIImage {
      
      let size = CGFloat(20)
      
      let newIcon = icon(size)
      newIcon?.addAttribute(
          NSAttributedString.Key.foregroundColor.rawValue,
        value: UIColor.lightGray.withAlphaComponent(0.5)
      )
      
      return newIcon!.image(with: CGSize(width: size, height: size))
      
    }

}
