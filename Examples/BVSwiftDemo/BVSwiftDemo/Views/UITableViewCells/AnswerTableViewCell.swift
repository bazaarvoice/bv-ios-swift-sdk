//
//  AnswerTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 09/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var writtenAtLabel: UILabel!
    @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
    @IBOutlet weak var authorNicknameLabel: UILabel!
    
    var answer: BVAnswer?
    
    var onAuthorNickNameTapped : ((_ authorId : String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setAnswerDetails(answer: BVAnswer) {

        self.answer = answer
        
        if let userNickname = answer.userNickname {
            self.authorNicknameLabel.linkAuthorNameLabel(fullText: userNickname,
                                                         author: userNickname,
                                                         target: self,
                                                         selector: #selector(AnswerTableViewCell.tappedAuthor(_:)))
        } else {
            self.authorNicknameLabel.text = ""
        }
        
        answerTextLabel.text = answer.answerText
        
        if let submissionTime = answer.submissionTime {
            writtenAtLabel.text = dateTimeAgo(submissionTime)
        }
        else {
            writtenAtLabel.text = ""
        }
        
        if let totalFeedbackCount = answer.totalFeedbackCount,
            let totalPositiveFeedbackCount = answer.totalPositiveFeedbackCount,
            totalFeedbackCount > 0 {
            
            let totalFeedbackCountString = "\(totalFeedbackCount)"
            let totalPositiveFeedbackCountString = "\(totalPositiveFeedbackCount)"
            
            let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this answer helpful"
            
            let attributedString = NSMutableAttributedString(string: helpfulText as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12.0)])
            
            let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)]
            let colorFontAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            
            // Part of string to be bold
            attributedString.addAttributes(boldFontAttribute, range: (helpfulText as NSString).range(of: totalFeedbackCountString))
            attributedString.addAttributes(boldFontAttribute, range: (helpfulText as NSString).range(of: totalPositiveFeedbackCountString))
            
            // Make text black
            attributedString.addAttributes(colorFontAttribute , range: (helpfulText as NSString).range(of: totalFeedbackCountString, options: .backwards))
            attributedString.addAttributes(colorFontAttribute , range: (helpfulText as NSString).range(of: totalPositiveFeedbackCountString))
            
            usersFoundHelpfulLabel.attributedText = attributedString
        }
        else {
            usersFoundHelpfulLabel.text = ""
        }
    }
    
    @objc func tappedAuthor(_ sender:UITapGestureRecognizer) {
        
        guard let authorId = self.answer?.authorId else { return }
        
        guard let onAuthorNameTapped = self.onAuthorNickNameTapped else { return }
        
        onAuthorNameTapped(authorId)
    }
    
}
