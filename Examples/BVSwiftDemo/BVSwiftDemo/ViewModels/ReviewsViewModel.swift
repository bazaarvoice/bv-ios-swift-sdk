//
//  ReviewsViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

private struct ReviewHighlightsSection {
    let type: ReviewHighlightsType
    var isExpand: Bool = false
}

private enum ReviewHighlightsType: Int, CaseIterable {
    
    case pros
    case cons
    
    var title: String {
        switch self {
        case .pros:
            return "Pros Mentioned"
        case .cons:
            return "Cons mentioned"
        }
    }
}

protocol ReviewsViewModelDelegate: class {
    
    func fetchReviews()
        
    var isReviewHighlightsExpanded: Bool { get }
        
    var numberOfSectionsForReviews: Int { get }
    
    var numberOfRowsForReview: Int { get }
        
    func numberOfRowsForReviewHighlights(_ section: Int) -> Int
    
    var numberOfSectionsForReviewHighlights: Int { get }
    
    func reviewHighlightsHeaderTitleForIndexPath(_ indexPath: IndexPath) -> String
    
    func reviewHighlightsCountForIndexPath(_ indexPath: IndexPath) -> Int
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String
        
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview?
        
    func didSelectRowAt(_ indexPath: IndexPath)
    
    func getBvReviewHighlightsData() -> BVReviewHighlights?
    
    var productName: String? { get }
    
    var productImageURL: URL? { get }
    
}

class ReviewsViewModel: ViewModelType {
    
    weak var viewController: ReviewsViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private var bvReviews: [BVReview]?
    
    private var bvReviewHighlights: BVReviewHighlights?
    
    private var productId: String = ""
    
    private var product: BVProduct? = nil
    
    private let dispatchGroup = DispatchGroup()
    
    private var error: Error?
    
    private var reviewHighlightsSections: [ReviewHighlightsSection] = [ReviewHighlightsSection(type: .pros),
                                                                      ReviewHighlightsSection(type: .cons)]
    
    init(productId: String, product: BVProduct) {
        self.productId = productId
        self.product = product
    }
}

extension ReviewsViewModel: ReviewsViewModelDelegate {
    
    func getBvReviewHighlightsData() -> BVReviewHighlights? {
        return self.bvReviewHighlights
    }
    
    var productName: String? {
        return self.productId
    }
    
    var productImageURL: URL? {
        return self.product?.imageUrl?.value
    }
    
    func fectchReviewData() {
        
        self.dispatchGroup.enter()
        
        let reviewQuery = BVReviewQuery(productId: "test1", limit: 10, offset: 10)
            .configure(ConfigurationManager.sharedInstance.conversationsConfig)
            .handler { [weak self] response in
                
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case let .failure(errors):
                    strongSelf.error = errors.first
                    
                    
                case let .success(_, reviews):
                    strongSelf.bvReviews = reviews
                }
                
                strongSelf.dispatchGroup.leave()
        }
        
        reviewQuery.async()
    }
    
    func fetchReviewHighligtsData() {
        
        self.dispatchGroup.enter()
        
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod1011")
            .configure(ConfigurationManager.sharedInstance.reviewHighlightsConfig)
            .handler { [weak self] response in
                
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case let .failure(errors):
                    
                    strongSelf.error = errors.first
                    
                case let .success(reviewHighlights):
                    strongSelf.bvReviewHighlights = reviewHighlights
                    
                }
                
                strongSelf.dispatchGroup.leave()
                
        }
        
        reviewHighlightsQuery.async()
        
    }
    
    func fetchReviews() {
        
        guard let delegate = self.viewController else { return }
        
        delegate.showLoadingIndicator()
        
        self .fectchReviewData()
        
        self.fetchReviewHighligtsData()
        
        self.dispatchGroup.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            delegate.hideLoadingIndicator()
            
            // check for PDP API error
            if let error = strongSelf.error {
                let errorMessage = (error as? BVError)?.message ?? "Something went wrong."
                strongSelf.coordinator?.showAlert(title: "", message: errorMessage, handler: {
                    strongSelf.coordinator?.popBack()
                })
                return
            }
            
            strongSelf.viewController?.reloadData()
            
        }
        
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
        for (index, _) in self.reviewHighlightsSections.enumerated() {
            
            if index == indexPath.section {
                self.reviewHighlightsSections[index].isExpand = !self.reviewHighlightsSections[index].isExpand
            }
            else {
                self.reviewHighlightsSections[index].isExpand = false
            }
        }
    }
    
    
    func reviewHighlightsHeaderTitleForIndexPath(_ indexPath: IndexPath) -> String {
        return self.reviewHighlightsSections[indexPath.section].type.title
    }
    
    
    var numberOfSectionsForReviews: Int {
        return 1
    }
    
    var numberOfRowsForReview: Int {
        return self.bvReviews?.count ?? 0
    }
    
    var numberOfSectionsForReviewHighlights: Int {
        return self.reviewHighlightsSections.count
    }
    
    func numberOfRowsForReviewHighlights(_ section: Int) -> Int {
        
        let reviewHighlightSection = self.reviewHighlightsSections[section]
        
        switch reviewHighlightSection.type {
            
        case .pros:
            return reviewHighlightSection.isExpand ? (self.bvReviewHighlights?.positives?.count ?? 0) + 1 : 1
            
        case .cons:
             return reviewHighlightSection.isExpand ? (self.bvReviewHighlights?.negatives?.count ?? 0) + 1 : 1
            
        }
    }
    
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview? {
        return self.bvReviews?[indexPath.row]
    }
    
    var isReviewHighlightsExpanded: Bool {
        return (self.reviewHighlightsSections.first(where: { $0.type == .pros })?.isExpand ?? false ||
                self.reviewHighlightsSections.first(where: { $0.type == .cons })?.isExpand ?? false)
            
    }
    
    func reviewHighlightsCountForIndexPath(_ indexPath: IndexPath) -> Int {
        
        let reviewHighlightSection = self.reviewHighlightsSections[indexPath.section]
        
        switch reviewHighlightSection.type {
            
        case .pros:
            return self.bvReviewHighlights?.positives?.count ?? 0
            
        case .cons:
             return self.bvReviewHighlights?.negatives?.count ?? 0
            
        }
    }
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String {
        
        let reviewHighlightSection = self.reviewHighlightsSections[indexPath.section]
        
        switch reviewHighlightSection.type {
            
        case .pros:
            return self.bvReviewHighlights?.positives?[indexPath.row - 1].title ?? ""
            
        case .cons:
             return self.bvReviewHighlights?.negatives?[indexPath.row - 1].title ?? ""
            
        }
    }
}
