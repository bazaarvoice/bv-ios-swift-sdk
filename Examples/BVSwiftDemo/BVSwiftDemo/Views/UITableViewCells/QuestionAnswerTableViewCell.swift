//
//  QuestionAnswerTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 28/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift
import FontAwesomeKit

class QuestionAnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionMetaData: UILabel!
    @IBOutlet weak var questionBody: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var callToActionLeftImageView: UIImageView!
    @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
    
    var onAuthorNickNameTapped : ((_ authorId : String) -> Void)?
   
    var onReadAnswersTapped : ((_ question : BVQuestion) -> Void)?
    
    var onSubmitAnswersTapped : ((_ question : BVQuestion) -> Void)?
    
    var question: BVQuestion?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setQuestionDetails(question: BVQuestion, isOnlyQuestion: Bool) {
        
        // question details
        self.questionTitle.text = question.questionSummary
        
        self.questionBody.text  = question.questionDetails
        
        if let userNickname = question.userNickname {
            self.questionMetaData.linkAuthorNameLabel(fullText: "Asked by " + userNickname,
                                                      author: userNickname,
                                                      target: self,
                                                      selector: #selector(QuestionAnswerTableViewCell.tappedAuthor(_:)))
        }
        else {
            self.questionMetaData.text = ""
        }
        
        if !isOnlyQuestion {
            
            if let totalFeedbackCount = question.totalFeedbackCount,
                let totalPositiveFeedbackCount = question.totalPositiveFeedbackCount,
                totalFeedbackCount > 0 {
                
                let totalFeedbackCountString = "\(totalFeedbackCount)"
                let totalPositiveFeedbackCountString = "\(totalPositiveFeedbackCount)"
                
                let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this question helpful"
                
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
            
            
            // call to action
            if let answers = question.answers, !answers.isEmpty {
                let title = "Read \(answers.count) " + ((answers.count == 1) ? "answer" : "answers")
                self.callToActionButton.setTitle(title, for: .normal)
                self.callToActionButton.addTarget(self, action: #selector(QuestionAnswerTableViewCell.readAnswersTapped(_:)), for: .touchUpInside)
                
                self.callToActionLeftImageView.image = self.getIconImage(FAKFontAwesome.commentsIcon(withSize:))
            }
            else {
                self.callToActionButton.setTitle("Be the first to answer!", for: .normal)
                self.callToActionButton.addTarget(self, action: #selector(QuestionAnswerTableViewCell.submitAnswersTapped(_:)), for: .touchUpInside)
                self.callToActionLeftImageView.image = self.getIconImage(FAKFontAwesome.plusIcon(withSize:))
            }
        }
        // store question
        self.question = question
    }
    
    @objc func tappedAuthor(_ sender:UITapGestureRecognizer){
        
        guard let authorId = self.question?.authorId else { return }
        
        guard let onAuthorNameTapped = self.onAuthorNickNameTapped else { return }
        
        onAuthorNameTapped(authorId)
    }
    
    @objc func readAnswersTapped(_ sender:UITapGestureRecognizer){
        
        guard let question = self.question else { return }
        
        guard let onReadAnswersTapped = self.onReadAnswersTapped else { return }
        
        onReadAnswersTapped(question)
    }
    
    @objc func submitAnswersTapped(_ sender:UITapGestureRecognizer){
        
        guard let question = self.question else { return }
        
        guard let onSubmitAnswersTapped = self.onSubmitAnswersTapped else { return }
        
        onSubmitAnswersTapped(question)
    }
    
    
    private func getIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?)) -> UIImage {
        
        let size = CGFloat(20)
        
        let newIcon = icon(size)
        newIcon?.addAttribute(
            NSAttributedString.Key.foregroundColor.rawValue,
            value: UIColor.lightGray.withAlphaComponent(0.5)
        )
        
        return newIcon!.image(with: CGSize(width: size, height: size))
        
    }
}
