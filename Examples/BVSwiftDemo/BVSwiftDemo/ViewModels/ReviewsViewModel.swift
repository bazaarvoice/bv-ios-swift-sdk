//
//  ReviewsViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

private enum ReviewHighlightsSection: Equatable {
    
    case pros(isExpand: Bool)
    case cons(isExpand: Bool)
    
    var title: String {
        switch self {
        case .pros(_):
            return "Pros Mentioned"
        case .cons(_):
            return "Cons mentioned"
        }
    }
    
    static func == (lhs: ReviewHighlightsSection, rhs: ReviewHighlightsSection) -> Bool {
        switch (lhs, rhs) {
            
        case (.pros(_), .pros(_)): return true
            
        case (.cons(_), .cons(_)): return true
            
        default: return false
        }
    }
}

protocol ReviewsViewModelDelegate: class {
    
    func fetchReviews()
    
    func didChangeFilterOption(_ option : ReviewsViewModel.FilterOptions)
    
    var isReviewHighlightsExpanded: Bool { get }
    
    var numberOfSectionsForReviews: Int { get }
    
    var numberOfRowsForReview: Int { get }

    func numberOfRowsForReviewHighlights(_ section: Int) -> Int
    
    func writeReviewTapped()
    
    func sortButtonTapped(_ viewController: UIViewController)
    
    var numberOfSectionsForReviewHighlights: Int { get }
    
    func reviewHighlightsHeaderTitleForIndexPath(_ indexPath: IndexPath) -> String
    
    func reviewHighlightsCountForIndexPath(_ indexPath: IndexPath) -> Int
    
    func gotoAuthorProfile(authorId: String)
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String
    
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview?
    
    func didSelectRowAt(_ indexPath: IndexPath)
    
    func getBvReviewHighlightsData() -> BVReviewHighlights?
    
    var productName: String? { get }
    
    var productRating: Double? { get }
    
    var productImageURL: URL? { get }
    
}

class ReviewsViewModel: ViewModelType {
    
    weak var viewController: ReviewsViewControllerDelegate?
    
    private var selectedFilterOption: FilterOptions = FilterOptions.mostRecent
    
    weak var coordinator: Coordinator?
    
    private var bvReviews: [BVReview]?
    
    private var bvReviewHighlights: BVReviewHighlights?
    
    private let productId: String
    
    private let product: BVProduct
    
    private let dispatchGroup = DispatchGroup()
    
    private var error: Error?
    
    private var reviewHighlightsSections: [ReviewHighlightsSection] = [.pros(isExpand: false),
                                                                       .cons(isExpand: false)]
    
    enum FilterOptions : String, CaseIterable {
        
        case mostRecent = "Most Recent"
        case highestRating = "Highest Rating"
        case lowestRating = "Lowest Rating"

    }
    
    init(productId: String, product: BVProduct) {
        self.productId = productId
        self.product = product
    }
}

extension ReviewsViewModel: ReviewsViewModelDelegate {
    
    func writeReviewTapped() {
        self.coordinator?.navigateTo(AppCoordinator.AppNavigation.writeReview(product: self.product))
    }
    
    func sortButtonTapped(_ viewController: UIViewController) {
        self.coordinator?.presentController(viewController)
    }
    
    func didChangeFilterOption(_ option : FilterOptions) {
        
        if self.selectedFilterOption == option {
            return // ignore, didn't change anything
        }

        self.selectedFilterOption = option

        self.fectchReviewData(isSortRequest: true)
        
    }
    
    func getBvReviewHighlightsData() -> BVReviewHighlights? {
        return self.bvReviewHighlights
    }
    
    var productName: String? {
        return self.product.name
    }
    
    var productRating: Double? {
        return self.product.reviewStatistics?.averageOverallRating
    }
    
    var productImageURL: URL? {
        return self.product.imageUrl?.value
    }
    
    private func fectchReviewData(isSortRequest: Bool) {
        
        isSortRequest ? self.viewController?.showLoadingIndicator() :  self.dispatchGroup.enter()
        
        let reviewQuery = BVReviewQuery(productId: self.productId, limit: 10, offset: 10)
        
        // Check sorting and filter FilterOptions
        switch selectedFilterOption {
            
        case .highestRating: reviewQuery.sort(.rating, order: .descending)
        case .lowestRating: reviewQuery.sort(.rating, order: .ascending)
        case .mostRecent : break
            
        }
        
        reviewQuery
            .configure(ConfigurationManager.sharedInstance.conversationsConfig)
            .handler { [weak self] response in
                
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case let .failure(errors):
                    strongSelf.error = errors.first
                    
                case let .success(_, reviews):
                    strongSelf.bvReviews = reviews
                }
                
                if isSortRequest {
                    DispatchQueue.main.async {
                        strongSelf.viewController?.hideLoadingIndicator()
                        strongSelf.viewController?.updateSortButtonTitle(title: "Sort: \(strongSelf.selectedFilterOption.rawValue)")
                            
                        strongSelf.viewController?.reloadData()
                    }
                }
                else {
                    strongSelf.dispatchGroup.leave()
                }
        }
        
        reviewQuery.async()
    }
    
    private func fetchReviewHighlightsData() {
        
        self.dispatchGroup.enter()
        
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: ConfigurationManager.sharedInstance.reviewHighlightsClientId, productId: ConfigurationManager.sharedInstance.reviewHighlightsProductId)
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
        
        self.fectchReviewData(isSortRequest: false)
        
        self.fetchReviewHighlightsData()
        
        self.dispatchGroup.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            delegate.hideLoadingIndicator()
            
            // check for Review API error
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
    
    private func isHeaderRow(rowIndex: Int, indexPath: IndexPath) -> Bool {
        return rowIndex == indexPath.section
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        
        for (index, _) in self.reviewHighlightsSections.enumerated() {
            
            let reviewHighlightsSection = self.reviewHighlightsSections[index]
            
            switch reviewHighlightsSection {
                
            case let .pros(isExpand):
                self.reviewHighlightsSections[index] = isHeaderRow(rowIndex: index, indexPath: indexPath) ? .pros(isExpand: !isExpand) : .pros(isExpand: false)
                
            case let .cons(isExpand):
                self.reviewHighlightsSections[index] = isHeaderRow(rowIndex: index, indexPath: indexPath) ? .cons(isExpand: !isExpand) : .cons(isExpand: false)
                
            }
        }
    }
    
    
    func reviewHighlightsHeaderTitleForIndexPath(_ indexPath: IndexPath) -> String {
        return self.reviewHighlightsSections[indexPath.section].title
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
        
        switch reviewHighlightSection {
            
        case let .pros(isExpand):
            return isExpand ? (self.bvReviewHighlights?.positives?.count ?? 0) + 1 : 1
            
        case let .cons(isExpand):
            return isExpand ? (self.bvReviewHighlights?.negatives?.count ?? 0) + 1 : 1
            
        }
    }
    
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview? {
        return self.bvReviews?[indexPath.row]
    }
    
    var isReviewHighlightsExpanded: Bool {
        
        return self.reviewHighlightsSections.contains { (reviewHighlightsSection) -> Bool in
            
            switch reviewHighlightsSection {
                
            case let .pros(isExpand) :
                return isExpand == true
                
            case let .cons(isExpand) :
                return isExpand == true
            }
        }
    }
    
    func reviewHighlightsCountForIndexPath(_ indexPath: IndexPath) -> Int {
        
        let reviewHighlightSection = self.reviewHighlightsSections[indexPath.section]
        
        switch reviewHighlightSection {
            
        case .pros:
            return self.bvReviewHighlights?.positives?.count ?? 0
            
        case .cons:
            return self.bvReviewHighlights?.negatives?.count ?? 0
            
        }
    }
    
    func gotoAuthorProfile(authorId: String) {
        self.coordinator?.navigateTo(AppCoordinator.AppNavigation.author(authorId: authorId))
    }
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String {
        
        let reviewHighlightSection = self.reviewHighlightsSections[indexPath.section]
        
        switch reviewHighlightSection {
            
        case .pros:
            return self.bvReviewHighlights?.positives?[indexPath.row - 1].title ?? ""
            
        case .cons:
            return self.bvReviewHighlights?.negatives?[indexPath.row - 1].title ?? ""
            
        }
    }
}
