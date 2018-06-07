//
//  MyAnswerTableViewCell.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class MyAnswerTableViewCell: BVTableViewCell<BVAnswer> {
  
  @IBOutlet weak var answerTestLabel : UILabel!
  
  override var bvType: BVAnswer? {
    didSet {
      if let text = bvType?.answerText {
        answerTestLabel.text = text
      }
    }
  }
}
