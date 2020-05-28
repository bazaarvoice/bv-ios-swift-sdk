//
//  QuestionAnswerTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 28/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class QuestionAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionMetaData: UILabel!
    @IBOutlet weak var questionBody: UILabel!
    
    var onAuthorNickNameTapped : ((_ authorId : String) -> Void)? = nil
    var authorId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setQuestionDetails(question: BVQuestion) {
        
        self.questionTitle.text = question.questionSummary
        
        self.questionBody.text  = question.questionDetails
        
        if let userNickname = question.userNickname {
          self.questionMetaData.linkAuthorNameLabel(fullText: "Asked by " + userNickname,
                                                    author: userNickname,
                                                    target: self,
                                                    selector: #selector(QuestionAnswerTableViewCell.tappedAuthor(_:)))
        }
        else {
          questionMetaData.text = ""
        }
        
        self.authorId = question.authorId
    }
    
    @objc func tappedAuthor(_ sender:UITapGestureRecognizer){
        
        guard let authorId = self.authorId else { return }

        guard let onAuthorNameTapped = self.onAuthorNickNameTapped else { return }
        
        onAuthorNameTapped(authorId)
    }
}
