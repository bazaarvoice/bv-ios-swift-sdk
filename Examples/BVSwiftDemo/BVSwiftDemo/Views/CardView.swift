//
//  CardView.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 28/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class CardView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 0
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.5
    
  }
}
