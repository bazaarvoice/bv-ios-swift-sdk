//
//  AnswerTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 09/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var writtenAtLabel: UILabel!
    @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
    @IBOutlet weak var authorNicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
