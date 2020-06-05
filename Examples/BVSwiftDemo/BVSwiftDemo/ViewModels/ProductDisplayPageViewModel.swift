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
    
    func fetchProductDisplayPageDetails()
    
    var numberOfSections: Int { get }
    
    var numberOfRows: Int { get }
    
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
    
    private enum ProductDisplayPageRow: Int, CaseIterable {
        
        case reviews
        
        case questions
        
        case curations
        
        case curationsAddPhoto
        
        case curationsPhotoMap
    }
    
    // MARK:- Initializers
    init(productId: String) {
        self.productId = productId
    }
}

// MARK:- ProductDisplayPageViewModelDelegate
extension ProductDisplayPageViewModel: ProductDisplayPageViewModelDelegate {
    
    func fetchProductDisplayPageDetails() {
        
        // TODO:- Testing Required after Bug fix(Bug in BVSwift SDK - When multiple stats are added they are passed as separate query params. So only first stat added will be returned).
        let productQuery = BVProductQuery(productId: self.productId)
            .stats(.questions)
            .stats(.reviews)
            .configure(ConfigurationManager.sharedInstance.config)
            .handler { [weak self] (response: BVConversationsQueryResponse<BVProduct>) in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    switch response {
                        
                    case let .failure(errors):
                        
                        let errorMessage = (errors.first as? BVError)?.message ?? "Something went wrong."
                        strongSelf.coordinator?.showAlert(title: "", message: errorMessage, handler: {
                            strongSelf.coordinator?.popBack()
                        })
                        
                    case let .success(_, products):
                        
                        // save product
                        strongSelf.product = products.first
                        
                        // update UI
                        if let name = strongSelf.product?.name, let imageURL = strongSelf.product?.imageUrl?.value {
                            strongSelf.viewController?.updateProductDetails(name: name, imageURL: imageURL)
                        }
                        strongSelf.viewController?.reloadData()
                        
                    }
                }
        }
        
        productQuery.async()
    }
    
    func fetchCurations() {
        
        let feedItemQuery = BVCurationsFeedItemQuery()
            .configure(ConfigurationManager.sharedInstance.curationsConfig)
            .field(.groups(["__all__"]))
            .field(.productId(BVIdentifier.string(self.productId)))
            .handler { [weak self] response in
                
                guard let strongSelf = self else { return }
                
                if case let .failure(errors) = response {
                    print(errors)
                    return
                }
                
                guard case let .success(_, results) = response else {
                    return
                }
                
                // save curations feed item
                strongSelf.curationsFeedItems = results
        }
        
        feedItemQuery.async()
        
    }
    
    func fetchRecommendations() {
        
        let recommendationsQuery = BVRecommendationsProfileQuery()
            .field(.product(self.productId))
            .configure(ConfigurationManager.sharedInstance.recommendationsConfig)
            .handler { [weak self] (response) in
                
                guard let strongSelf = self else { return }
                
                if case let .failure(errors) = response {
                  print(errors)
                  return
                }
                
                guard case let .success(_, result) = response else {
                  return
                }
                
                // save recommendations
                strongSelf.recommendations = result.first?.products
        }
        
        recommendationsQuery.async()
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfRows: Int {
        return ProductDisplayPageRow.allCases.count
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
            
        }        
    }
}
