//
//  ReviewsViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

enum ReviewTableSections {
    
    case features
    case summary
    case pros
    case cons
    case positiveQuotes
    case negativeQuotes
    case featureQuotes
    case quotes
    case actionButtons
    case reviews
    
    var title: String {
        switch self {
            
        case .features:
            return "Product Features"
        case .summary:
            return "✨ AI Generated Review Summary"
        case .pros:
            return "Pros"
        case .cons:
            return "Cons"
        case .positiveQuotes:
            return "Most Helpful Review Quotes"
        case .negativeQuotes:
            return "Most Critical Review Quotes"
        case .featureQuotes:
            return "Quotes for Feature"
        case .quotes:
            return "Most Useful Quotes"
        case .actionButtons:
            return "Actions"
        case .reviews:
            return "Reviews"
        }
    }
}

protocol ReviewsViewModelDelegate: AnyObject {
    
    func fetchReviews()
    
    func didChangeFilterOption(_ option : ReviewsViewModel.FilterOptions)
        
    var reviewTableSections: [ReviewTableSections] { get }
    
    var numberOfSections: Int { get }

    func numberOfRowsInSection(_ section: Int) -> Int
        
    func writeReviewTapped()
    
    func sortButtonTapped(_ viewController: UIViewController)
    
    var sortButtonTitle: String { get }
        
    func headerTitleForSection(_ section: Int) -> String
        
    func gotoAuthorProfile(authorId: String)
        
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview?
    
    func didSelectRowAt(_ indexPath: IndexPath)
        
    var productName: String? { get }
    
    var productRating: Double? { get }
    
    var productImageURL: URL? { get }
    
//}
//
    
    func toggleReviewHighlights(isOn: Bool)
    
    var displayReviewHighlights: Bool { get }
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String
    
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

    var displayReviewHighlights: Bool = false
    var productSentimentsViewModel: ProductSentimentsViewModelDelegate?

        
    enum FilterOptions : String, CaseIterable {
        
        case mostRecent = "Most Recent"
        case highestRating = "Highest Rating"
        case lowestRating = "Lowest Rating"

    }
    
    init(productId: String, product: BVProduct) {
        self.productId = productId
        self.product = product
        self.productSentimentsViewModel = ProductSentimentsViewModel(productId: productId)
        self.productSentimentsViewModel?.productSentimentsUIDelegate = self
    }
}

extension ReviewsViewModel: ReviewsViewModelDelegate {
    var sortButtonTitle: String {
        "Sort: " + self.selectedFilterOption.rawValue
    }
    
    var reviewTableSections: [ReviewTableSections] {
        if displayReviewHighlights {
            return [
                .summary,
                .features,
                .quotes,
                .pros,
                .cons,
//                .positiveQuotes,
//                .negativeQuotes,
                .featureQuotes,
                .actionButtons,
                .reviews
            ]
        } else {
            return [
                .summary,
                .actionButtons,
                .reviews
            ]
        }
    }
    
    var numberOfSections: Int {
        return self.reviewTableSections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        let type = self.reviewTableSections[section]
        switch type {
        case .actionButtons:
            return 1
        case .reviews:
            return self.bvReviews?.count ?? 0
        default:
            return self.productSentimentsViewModel?.getRowCount(type) ?? 0
        }
    }
    
    func headerTitleForSection(_ section: Int) -> String {
        return self.reviewTableSections[section].title
    }
    
    
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
        let type = self.reviewTableSections[indexPath.section]
        if type == .features || type == .pros || type == .cons {
            self.productSentimentsViewModel?.didSelectFeatureAtIndex(type, indexPath.row)
        }
    }
    
    var numberOfRowsForReview: Int {
        return self.bvReviews?.count ?? 0
    }
    
    func reviewForIndexPath(_ indexPath: IndexPath) -> BVReview? {
        return self.bvReviews?[indexPath.row]
    }
    
    func gotoAuthorProfile(authorId: String) {
        self.coordinator?.navigateTo(AppCoordinator.AppNavigation.author(authorId: authorId))
    }
    
}

extension ReviewsViewModel{//}: ReviewHighlightsViewModelDelegate {
    func toggleReviewHighlights(isOn: Bool) {
        displayReviewHighlights = isOn
    }
    
    func reviewHighlightsTitleForIndexPath(_ indexPath: IndexPath) -> String {
        return self.productSentimentsViewModel?.getText(self.reviewTableSections[indexPath.section], indexPath.row) ?? ""
    }
}

extension ReviewsViewModel: ProductSentimentsUIDelegate {
    func reloadData() {
        self.viewController?.reloadData()
    }
    
}

