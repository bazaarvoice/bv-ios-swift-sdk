//
//  AuthorViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 16/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

protocol AuthorViewModelDelegate {
    
    var userProfileImageURL: URL? { get }
    
    var userName: String { get }
    
    var userLoaction: String { get }
    
    var userBadges: String { get }
    
    var reviewButtonText: String { get }
    
    var questionButtonText: String { get }
    
    var answerButtonText: String { get }
    
    var numberOfSectionsForReview: Int { get }
    
    var numberOfRowsForReview: Int { get }
    
    var numberOfSectionsForQuestion: Int { get }
    
    var numberOfRowsForQuestion: Int { get }
    
    var numberOfSectionsForAnswer: Int { get }
    
    var numberOfRowsForAnswer: Int { get }
    
    func fetchAuthorProfile()
    
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview?
    
    func questionForIndexPath(_ indexPath: IndexPath) -> BVQuestion?
    
    func answerForIndexPath(_ indexPath: IndexPath) -> BVAnswer?
    
}

class AuthorViewModel: ViewModelType {
    
    var coordinator: Coordinator?
    
    weak var viewController: AuthorViewControllerDelegate?
    
    private var bvAuthor: [BVAuthor]?
    
    private var error: Error?
    
    private static var config: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "conciergeapidocumentation"))
        
        return BVConversationsConfiguration.display(
            clientKey: "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4",
            configType: .staging(clientId: "conciergeapidocumentation"),
            analyticsConfig: analyticsConfig)
    }()
}

extension AuthorViewModel : AuthorViewModelDelegate {
    
    var reviewButtonText: String {
        
        if let totalReviewCount = self.bvAuthor?.first?.reviewStatistics?.totalReviewCount {
            return "Reviews (\(totalReviewCount))"
        }
        else {
            return "Reviews 0"
        }
    }
    
    var questionButtonText: String {
        
        if let totalQuestionCount = self.bvAuthor?.first?.qaStatistics?.totalQuestionCount {
            return "Questions (\(totalQuestionCount))"
        }
        else {
            return "Questions 0"
        }
    }
    
    var answerButtonText: String {
        
        if let totalAnswerCount = self.bvAuthor?.first?.qaStatistics?.totalAnswerCount {
            return "Answers (\(totalAnswerCount))"
        }
        else {
            return "Answers 0"
        }
    }
    
    var numberOfSectionsForReview: Int {
        return 1
    }
    
    var numberOfRowsForReview: Int {
        
        guard let rowsCount = self.bvAuthor?.first?.reviews?.count else { return 0 }
        
        return rowsCount
    }
    
    var numberOfSectionsForQuestion: Int {
        return 1
    }
    
    var numberOfRowsForQuestion: Int {
        
        guard let rowsCount = self.bvAuthor?.first?.questions?.count else { return 0 }
        
        return rowsCount
    }
    
    var numberOfSectionsForAnswer: Int {
        return 1
    }
    
    var numberOfRowsForAnswer: Int {
        
        guard let rowsCount = self.bvAuthor?.first?.answers?.count else { return 0 }
        
        return rowsCount
    }
    
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview? {
        
        guard let bVReview = self.bvAuthor?.first?.reviews?[indexPath.row] else { return nil }
        
        return bVReview
    }
    
    func questionForIndexPath(_ indexPath: IndexPath) -> BVQuestion? {
        
        guard let bVQuestion = self.bvAuthor?.first?.questions?[indexPath.row] else { return nil }
        
        return bVQuestion
    }
    
    func answerForIndexPath(_ indexPath: IndexPath) -> BVAnswer? {
        
        guard let bVAnswer = self.bvAuthor?.first?.answers?[indexPath.row] else { return nil }
        
        return bVAnswer
    }
    
    var userProfileImageURL: URL? {
        return self.bvAuthor?.first?.photos?.first?.photoSizes?.first?.url?.value
    }
    
    var userName: String {
        return bvAuthor?.first?.userNickname ?? ""
    }
    
    var userLoaction: String {
        return bvAuthor?.first?.userLocation ?? ""
    }
    
    var userBadges: String {
        return bvAuthor?.first?.badges?.first?.badgeId ?? ""
    }
    
    func fetchAuthorProfile() {
        
        guard let delegate = self.viewController else { return }
        
        delegate.showLoadingIndicator()
        
        let authorQuery = BVAuthorQuery(authorId: ConfigurationManager.sharedInstance.authorId)
//            .configure(ConfigurationManager.sharedInstance.conversationsConfig)
            // stats includes
            .stats(.answers)
            .stats(.questions)
            .stats(.reviews)
            
            // other includes
            .include(.reviews, limit: 20)
            .include(.questions, limit: 20)
            .include(.answers, limit: 20)
            
            // sorts
            .sort(.answers(.submissionTime), order: .descending)
            .sort(.reviews(.submissionTime), order: .descending)
            .sort(.questions(.submissionTime), order: .descending)
            
            .configure(AuthorViewModel.config)
            .handler { [weak self] response in
                
                delegate.hideLoadingIndicator()
                
                DispatchQueue.main.async {
                    
                    guard let strongSelf = self else { return }
                    
                    switch response {
                        
                    case let .failure(errors):
                        strongSelf.error = errors.first
                        
                    case let .success(_, bvAuthor):
                        strongSelf.bvAuthor = bvAuthor
                        
                        delegate.reloadData()
                        delegate.updateAuthorDetails()
                    }
                    
                }
        }
        
        authorQuery.async()
    }
    
}
