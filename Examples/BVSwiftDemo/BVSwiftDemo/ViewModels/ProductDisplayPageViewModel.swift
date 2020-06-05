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
        
        // TODO:- Testing Required after Bug fix(Bug in BVSwift SDK - When multiple stats are added they are passed as separate query params. So only first stat added will be returned).
        self.dispatchGroup.enter()
        
        let productQuery = BVProductQuery(productId: self.productId)
            .stats(.questions)
            .stats(.reviews)
            .configure(ConfigurationManager.sharedInstance.config)
            .handler { [weak self] (response: BVConversationsQueryResponse<BVProduct>) in
                
                guard let strongSelf = self else { return }
                
                    
                    switch response {
                        
                    case let .failure(errors):
                       print(errors)
                        
                    case let .success(_, products):
                        strongSelf.product = products.first

                    strongSelf.dispatchGroup.leave()
                }
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
            .configure(ConfigurationManager.sharedInstance.recommendationsConfig)
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
            
            self?.viewController?.hideLoadingIndicator()
            
            // update UI
            if let name = self?.product?.name, let imageURL = self?.product?.imageUrl?.value {
                self?.viewController?.updateProductDetails(name: name, imageURL: imageURL)
            }
            
            self?.viewController?.reloadData()
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
            
        case .curations: return "Curations"
            
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
            
        case .curations: return FAKFontAwesome.plugIcon(withSize:)
            
        case .curationsAddPhoto: return FAKFontAwesome.cameraRetroIcon(withSize:)
            
        case .curationsPhotoMap: return FAKFontAwesome.locationArrowIcon(withSize:)
            
        case .recommendations: return FAKFontAwesome.plugIcon(withSize:)
            
        }        
    }
}
