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
    
    var numberOfSections: Int { get }
    
    var numberOfRowsForReview: Int { get }
    
    var numberOfRowsForQuestion: Int { get }
    
    var numberOfRowsForAnswer: Int { get }
    
    func fetchAuthorProfile()
    
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview?
    
    func questionForIndexPath(_ indexPath: IndexPath) -> BVQuestion?
    
    func answerForIndexPath(_ indexPath: IndexPath) -> BVAnswer?
    
}

class AuthorViewModel: ViewModelType {
    
    var coordinator: Coordinator?
    
    weak var viewController: AuthorViewControllerDelegate?
    
    private var authorId: String
    
    private var bvAuthor: [BVAuthor]?
    
    private var error: Error?
    
    init(authorId: String) {
        self.authorId = authorId
    }
    
    enum SegmentControllerTypes: Int, CaseIterable {
        
        case Reviews
        
        case Questions
        
        case Answers
    }
    
    //Temp
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
        
        return "Reviews (\(self.bvAuthor?.first?.reviewStatistics?.totalReviewCount ?? 0))"
    }
    
    var questionButtonText: String {
        
        return "Questions (\(self.bvAuthor?.first?.qaStatistics?.totalQuestionCount ?? 0))"
    }
    
    var answerButtonText: String {
        
        return "Answer (\(self.bvAuthor?.first?.qaStatistics?.totalAnswerCount ?? 0))"
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRowsForReview: Int {
        
        return self.bvAuthor?.first?.reviews?.count ?? 0
    }
    
    var numberOfRowsForQuestion: Int {
        
        return self.bvAuthor?.first?.questions?.count ?? 0
    }
    
    var numberOfRowsForAnswer: Int {
        
        return self.bvAuthor?.first?.answers?.count ?? 0
    }
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview? {
        
        return self.bvAuthor?.first?.reviews?[indexPath.row]
    }
    
    func questionForIndexPath(_ indexPath: IndexPath) -> BVQuestion? {
        
        return self.bvAuthor?.first?.questions?[indexPath.row]
    }
    
    func answerForIndexPath(_ indexPath: IndexPath) -> BVAnswer? {
        
        return self.bvAuthor?.first?.answers?[indexPath.row]
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
        
        let authorQuery = BVAuthorQuery(authorId: self.authorId)
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
            
            .configure(ConfigurationManager.sharedInstance.conversationsConfig)
            // .configure(AuthorViewModel.config)
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
