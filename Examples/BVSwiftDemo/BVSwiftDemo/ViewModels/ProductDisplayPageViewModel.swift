//
//  ProductDisplayPageViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 02/06/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift
import FontAwesomeKit

protocol ProductDisplayPageViewModelDelegate: class {
    
    func fetchProductDisplayPageData()
    
    var numberOfSections: Int { get }
    
    var numberOfRows: Int { get }
    
    func rowTypeAtIndexPath(_ indexPath: IndexPath) -> ProductDisplayPageViewModel.ProductDisplayPageRow?
    
    func titleForIndexPath(_ indexPath: IndexPath) -> String
    
    func iconForIndexPath(_ indexPath: IndexPath) -> ((_ size: CGFloat) -> FAKFontAwesome?)
    
    var numberOfCurations: Int { get }
    
    func curationsFeedItemAtIndexPath(_ indexPath: IndexPath) -> BVCurationsFeedItem?
    
    var numberOfRecommendations: Int { get }
    
    func recommendationAtIndexPath(_ indexPath: IndexPath) -> BVRecommendationsProduct?
    
    func didSelectRowAtIndexPath(_ indexPath: IndexPath)
    
}

class ProductDisplayPageViewModel: ViewModelType {
    
    weak var viewController: ProductDisplayPageViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    // MARK:- Private properties
    
    private let productId: String
    
    private var product: BVProduct?
    
    private var curationsFeedItems: [BVCurationsFeedItem]?
    
    private var recommendations: [BVRecommendationsProduct]?
    
    private let dispatchGroup = DispatchGroup()
    
    private var error: Error?
    
    enum ProductDisplayPageRow: Int, CaseIterable {
        
        case reviews
        
        case questions
        
        case curations
        
        case curationsAddPhoto
        
        case curationsPhotoMap
        
        case recommendations
    }
    
    // MARK:- Initializers
    init(productId: String) {
        self.productId = productId
    }
    
    private func fetchProductDisplayPageDetails() {
        
        self.dispatchGroup.enter()
        
        let productQuery = BVProductQuery(productId: self.productId)
            .stats(.questions)
            .stats(.reviews)
            .configure(ConfigurationManager.sharedInstance.conversationsConfig)
            .handler { [weak self] (response: BVConversationsQueryResponse<BVProduct>) in
                
                guard let strongSelf = self else { return }
                
                
                switch response {
                    
                case let .failure(errors):
                    strongSelf.error = errors.first
                    
                case let .success(_, products):
                    strongSelf.product = products.first
                }
                
                strongSelf.dispatchGroup.leave()
                
        }
        
        productQuery.async()
    }
    
    private func fetchCurations() {
        
        self.dispatchGroup.enter()
        
        let feedItemQuery = BVCurationsFeedItemQuery()
            .configure(ConfigurationManager.sharedInstance.curationsConfig)
            .field(.groups(["__all__"]))
            .field(.productId(BVIdentifier.string(self.productId)))
            .handler { [weak self] response in
                
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case let .failure(errors):
                    print(errors)
                    
                case let .success(_, results):
                    strongSelf.curationsFeedItems = results
                }
                
                strongSelf.dispatchGroup.leave()
        }
        
        feedItemQuery.async()
        
    }
    
    private func fetchRecommendations() {
        
        self.dispatchGroup.enter()
        
        let recommendationsQuery = BVRecommendationsProfileQuery()
            .field(.product(self.productId))
            .configure(ConfigurationManager.sharedInstance.recommendationConfig)
            .handler { [weak self] (response) in
                
                guard let strongSelf = self else { return }
                
                switch response {
                    
                case let .failure(errors):
                    print(errors)
                    
                case let .success(_, results):
                    strongSelf.recommendations = results.first?.products
                }
                
                strongSelf.dispatchGroup.leave()
        }
        
        recommendationsQuery.async()
    }
}

// MARK:- ProductDisplayPageViewModelDelegate
extension ProductDisplayPageViewModel: ProductDisplayPageViewModelDelegate {
    
    func fetchProductDisplayPageData() {
        
        self.viewController?.showLoadingIndicator()
        
        self.fetchProductDisplayPageDetails()
        
        self.fetchCurations()
        
        self.fetchRecommendations()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.viewController?.hideLoadingIndicator()
            
            // check for PDP API error
            if let error = strongSelf.error {
                let errorMessage = (error as? BVError)?.message ?? "Something went wrong."
                strongSelf.coordinator?.showAlert(title: "", message: errorMessage, handler: {
                    strongSelf.coordinator?.popBack()
                })
                return
            }
            
            // update UI
            if let name = strongSelf.product?.name, let imageURL = strongSelf.product?.imageUrl?.value, let rating = strongSelf.product?.reviewStatistics?.averageOverallRating {
                strongSelf.viewController?.updateProductDetails(name: name, imageURL: imageURL, ratings: rating)
            }
            
            strongSelf.viewController?.reloadData()
        }
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return ProductDisplayPageRow.allCases.count
    }
    
    func rowTypeAtIndexPath(_ indexPath: IndexPath) -> ProductDisplayPageViewModel.ProductDisplayPageRow? {
        
        return ProductDisplayPageRow(rawValue: indexPath.row)
    }
    
    func titleForIndexPath(_ indexPath: IndexPath) -> String {
        
        guard let productDisplayPageRow = ProductDisplayPageRow(rawValue: indexPath.row) else {
            return ""
        }
        
        switch productDisplayPageRow {
            
        case .reviews: return "\(self.product?.reviewStatistics?.totalReviewCount ?? 0) Reviews"
            
        case .questions: return "\(self.product?.qaStatistics?.totalQuestionCount ?? 0) Questions, \(self.product?.qaStatistics?.totalAnswerCount ?? 0) Answers"
            
        case .curations: return ""
            
        case .curationsAddPhoto: return "Add your photo!"
            
        case .curationsPhotoMap: return "Photos by Location"
            
        case .recommendations: return ""
            
        }
    }
    
    func iconForIndexPath(_ indexPath: IndexPath) -> ((CGFloat) -> FAKFontAwesome?) {
        
        guard let productDisplayPageRow = ProductDisplayPageRow(rawValue: indexPath.row) else {
            return FAKFontAwesome.plugIcon(withSize:)
        }
        
        switch productDisplayPageRow {
            
        case .reviews: return FAKFontAwesome.commentsIcon(withSize:)
            
        case .questions: return FAKFontAwesome.questionCircleIcon(withSize:)
            
        case .curations: return FAKFontAwesome.plugIcon(withSize:)  // default Icon
            
        case .curationsAddPhoto: return FAKFontAwesome.cameraRetroIcon(withSize:)
            
        case .curationsPhotoMap: return FAKFontAwesome.locationArrowIcon(withSize:)
            
        case .recommendations: return FAKFontAwesome.plugIcon(withSize:) // default Icon
            
        }        
    }
    
    var numberOfCurations: Int {
        return self.curationsFeedItems?.count ?? 0
    }
    
    func curationsFeedItemAtIndexPath(_ indexPath: IndexPath) -> BVCurationsFeedItem? {
        return self.curationsFeedItems?[indexPath.row]
    }
    
    var numberOfRecommendations: Int {
        return self.recommendations?.count ?? 0
    }
    
    func recommendationAtIndexPath(_ indexPath: IndexPath) -> BVRecommendationsProduct? {
        return self.recommendations?[indexPath.row]
    }
    
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        
        guard let productDisplayPageRow = ProductDisplayPageRow(rawValue: indexPath.row) else {
            return
        }
        
        switch productDisplayPageRow {
            
        case .reviews: self.coordinator?.navigateTo(AppCoordinator.AppNavigation.review(productId: self.productId, product: self.product!))
            
        case .questions: self.coordinator?.navigateTo(AppCoordinator.AppNavigation.questions(productId: self.productId, product: self.product!))
            
        case .curations: break
            
        case .curationsAddPhoto: break
            
        case .curationsPhotoMap: break
            
        case .recommendations: break
            
        }
        
    }
}
