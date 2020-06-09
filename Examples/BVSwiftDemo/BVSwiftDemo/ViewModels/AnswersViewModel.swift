//
//  AnswersViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 09/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift

protocol AnswersViewModelDelegate: class {
    
    var productName: String? { get }
    
    var imageURL: URL? { get }
    
    var questionSummary: String? { get }
    
    var questionDetails: String? { get }
    
    var questionMetaData: String? { get }
    
    var numberOfSections: Int { get }
    
    var numberOfRows: Int { get }
    
    func answerForRowAtIndexPath(_ indexPath: IndexPath) -> BVAnswer?

}

class AnswersViewModel: ViewModelType {
    
    weak var viewController: AnswersViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private let question: BVQuestion
    
    private let product: BVProduct
    
    init(question: BVQuestion, product: BVProduct) {
        self.question = question
        self.product = product
    }
}

extension  AnswersViewModel: AnswersViewModelDelegate {
    var productName: String? {
        return self.product.productId
    }
    
    var imageURL: URL? {
        return self.product.imageUrl?.value
    }
    
    var questionSummary: String? {
        return question.questionSummary
    }
    
    var questionDetails: String? {
        return question.questionDetails
    }
    
    var questionMetaData: String? {
        if let submissionTime = question.submissionTime, let nickname = question.userNickname {
            return dateTimeAgo(submissionTime) + " by " + nickname
        }
        else if let nickname = question.userNickname {
            return nickname
        }
        else if let submissionTime = question.submissionTime {
            return dateTimeAgo(submissionTime) + " by Anonymous"
        }
        else {
            return "Anonymous"
        }
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return self.question.answers?.count ?? 0
    }
    
    func answerForRowAtIndexPath(_ indexPath: IndexPath) -> BVAnswer? {
        return self.question.answers?[indexPath.row]
    }
}
