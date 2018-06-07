//
//  MyQuestionTableViewCell.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class MyQuestionTableViewCell: BVTableViewCell<BVQuestion> {
  
  @IBOutlet weak var questionSummary : UILabel!
  @IBOutlet weak var questionDetails : UILabel!
  
  override var bvType: BVQuestion? {
    didSet {
      if let answers = bvType?.answers,
        0 < answers.count,
        let summary = bvType?.questionSummary {
        questionSummary.text = "\(summary)  (\(answers.count) Answers)"
        selectionStyle = .default
        accessoryType = .disclosureIndicator
      } else {
        selectionStyle = .none
        accessoryType = .none
      }
      
      if let details = bvType?.questionDetails {
        questionDetails.text = details
      }
    }
  }
}
