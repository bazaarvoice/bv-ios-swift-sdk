//
//  ReviewsViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

struct ReviewHighlightsHeaderModel {
    var title: String = ""
    var isExpand: Bool = false
}

enum ReviewHighlightsType {
    
    case pros(isExpand: Bool = false)
    case cons(isExpand: Bool = false)
    
    var title: String {
        switch self {
        case .pros:
            return "Pros Mentioned"
        case .cons:
            return "Cons mentioned"
        }
    }
    
    func typeForIntValue(_ value: Int) -> ReviewHighlightsType? {
        
        if value == 0 {
            return .pros(isExpand: false)
        }
            
        else if value == 1 {
            return .cons(isExpand: false)
        }
        else {
            return nil
        }
    }
}

protocol ReviewsViewModelDelegate: class {
    
    func fetchReviews()
    
    var reviewHighlightsHeaderType: [ReviewHighlightsHeaderModel] {get}
    
    var numberOfSectionsForReviews: Int { get }
    
    var numberOfRowsForReview: Int { get }
    
    func heightForRow(_ indexPath: IndexPath) -> CGFloat
    
    func numberOfRowsForReviewHighlights(_ section: Int) -> Int
    
    var numberOfSectionsForReviewHighlights: Int { get }
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String? //ReviewHighlightsType?
    
    func initReviewHighlightsHeaderArray() -> [ReviewHighlightsHeaderModel]
    
    func initReviewDataForIndexPath(_ indexPath: IndexPath) -> BVReview?
    
    func initReviewHighlightsDataForIndexPath(_ indexPath: IndexPath) -> BVReviewHighlight?
    
    func didSelectRowAt(_ indexPath: IndexPath)
    
    func getBvReviewHighlightsData() -> BVReviewHighlights?
    
    var productName: String? { get }
    
    var productImageURL: URL? { get }
    
}

class ReviewsViewModel: ViewModelType {
    
    weak var viewController: ReviewsViewControllerDelegate?
    
    private var headerType: [ReviewHighlightsHeaderModel] = [ReviewHighlightsHeaderModel(title: "Pros Mentioned", isExpand: false), ReviewHighlightsHeaderModel(title: "Cons mentioned", isExpand: false)]
    
    weak var coordinator: Coordinator?
    
    private var bvReviews: [BVReview]?
    
    private var bvReviewHighlights: BVReviewHighlights?
    
    private var productId: String = ""
    
    private var product: BVProduct? = nil
    
    private let dispatchGroup = DispatchGroup()
    
    private var error: Error?
    
    init(productId: String, product: BVProduct) {
        self.productId = productId
        self.product = product
    }
}

extension ReviewsViewModel: ReviewsViewModelDelegate {
    
    var reviewHighlightsHeaderType: [ReviewHighlightsHeaderModel] {
        return self.headerType
    }
    
    func heightForRow(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        else {
            return 40
        }
    }
    
    func getBvReviewHighlightsData() -> BVReviewHighlights? {
        return self.bvReviewHighlights
    }
    
    var productName: String? {
        return self.productId
    }
    
    var productImageURL: URL? {
        return self.product?.imageUrl?.value
    }
    
    func initReviewHighlightsDataForIndexPath(_ indexPath: IndexPath) -> BVReviewHighlight? {
        if indexPath.section == 0 {
            return self.bvReviewHighlights?.positives?[indexPath.row - 1]
        }
        
        return self.bvReviewHighlights?.negatives?[indexPath.row - 1]
        
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
    
    //Need to
    func didSelectRowAt(_ indexPath: IndexPath) {
        
        for i in 0..<self.headerType.count {
            
            if i == indexPath.section {
                self.headerType[indexPath.section].isExpand = !self.headerType[indexPath.section].isExpand
            }
            else {
                self.headerType[i].isExpand = false
            }
        }
        
    }
    
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String? {//ReviewHighlightsType? {
        
        return self.headerType[indexPath.section].title
    }
    
    
    var numberOfSectionsForReviews: Int {
        return 1
    }
    
    var numberOfRowsForReview: Int {
        return self.bvReviews?.count ?? 0
    }
    
    var numberOfSectionsForReviewHighlights: Int {
        return 2
    }
    
    func numberOfRowsForReviewHighlights(_ section: Int) -> Int {
        
        if let reviewHightData = self.bvReviewHighlights {
            if section == 0 {
                return self.headerType[section].isExpand ? (reviewHightData.positives?.count ?? 0) + 1 : 1
                
            }
            else {
                return self.headerType[section].isExpand ? (reviewHightData.negatives?.count ?? 0) + 1 : 1
            }
        }
        
        return 0
    }
    
    func initReviewDataForIndexPath(_ indexPath: IndexPath) -> BVReview? {
        return self.bvReviews?[indexPath.row]
    }
    
    func initReviewHighlightsHeaderArray() -> [ReviewHighlightsHeaderModel] {
        
        return [ReviewHighlightsHeaderModel(title: "Pros Mentioned", isExpand: false), ReviewHighlightsHeaderModel(title: "Cons mentioned", isExpand: false)]
    }
    
    
}
