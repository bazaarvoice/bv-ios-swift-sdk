//
//  Utils.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 20/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class var bazaarvoiceNavy : UIColor { return #colorLiteral(red: 0, green: 0.2392156863, blue: 0.3019607843, alpha: 1) }
    
    class var bazaarvoiceTeal : UIColor { return #colorLiteral(red: 0, green: 0.6705882353, blue: 0.5607843137, alpha: 1) }
    
    class var bazaarvoiceGold : UIColor { return #colorLiteral(red: 0.9882352941, green: 0.7176470588, blue: 0.06666666667, alpha: 1) }
    
    class var appBackground   : UIColor { return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) }
}

extension UILabel {
  
  func linkAuthorNameLabel(fullText : String, author : String, target: Any?, selector : Selector?) {
    
    let attributedString = NSMutableAttributedString(string: fullText)
    attributedString.setAttributes([:], range: NSRange(0..<attributedString.length)) // remove all the default attributes
    
    let colorFontAttribute = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    
    attributedString.addAttributes(colorFontAttribute , range: (fullText as NSString).range(of: author, options: .backwards))
    
    self.attributedText = attributedString
    self.isUserInteractionEnabled = true
    
    // Here the full label will be tappable. If you wanted to make just a part of the label
    // tappable you'd need to check the frame when tapped, or use a different label.
    let tapLabelGesture = UITapGestureRecognizer(target: target, action: selector)
    self.addGestureRecognizer(tapLabelGesture)
    
  }  
}
