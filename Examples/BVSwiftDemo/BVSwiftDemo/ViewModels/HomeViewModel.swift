//
//  HomeViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 19/05/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift

protocol HomeViewModelDelegate: class {
    var numberOfSections: Int { get }
    var numberOfItems: Int { get }
    func productForItemAtIndexPath(_ indexPath: IndexPath) -> BVRecommendationsProduct?
    func didSelectItemAt (indexPath: IndexPath)
    func loadProductRecommendations()
}

class HomeViewModel: ViewModelType {
    
    weak var viewController: HomeCollectionViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private var bVRecommendationsProduct: [BVRecommendationsProduct]?
    
}

extension HomeViewModel: HomeViewModelDelegate {
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfItems: Int {
        return self.bVRecommendationsProduct?.count ?? 0
    }
    
    func productForItemAtIndexPath(_ indexPath: IndexPath) -> BVRecommendationsProduct? {
        guard let recommendationsProduct = self.bVRecommendationsProduct?[indexPath.row] else {
            return nil
        }
        
        return recommendationsProduct
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        
        guard let productId = self.bVRecommendationsProduct?[indexPath.item].productId else {
            return
        }
        
        self.coordinator?.navigateTo(AppCoordinator.AppNavigation.productDisplayPage(productId: productId))
    }
    
    func loadProductRecommendations() {
        
        guard let delegate = self.viewController else { return }
        
        delegate.showLoadingIndicator()
        
        let recommendationQuery = BVRecommendationsProfileQuery()
        
        recommendationQuery
            .configure(ConfigurationManager.sharedInstance.recommendationConfig)
            .field(.brandId("610ce8a1-644f-4f02-8b6e-8b198376aa9d"))
            .field(.include(.interests))
            .field(.include(.categories))
            .field(.include(.brands))
            .field(.include(.recommendations))
            .handler { [weak self] response in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    delegate.hideLoadingIndicator()
                    
                    if case let .failure(error) = response {
                        let errorMessage = (error.first as? BVError)?.message ?? "Something went wrong."
                        strongSelf.coordinator?.showAlert(title: "", message: errorMessage, handler: {
                            strongSelf.coordinator?.popBack()
                        })
                        return
                    }
                    
                    guard case let .success(_, result) = response else {
                        strongSelf.coordinator?.showAlert(title: "", message: "Something went wrong.", handler: {
                            strongSelf.coordinator?.popBack()
                        })
                        return
                    }
                    
                    self?.bVRecommendationsProduct = result.first?.products
                    
                    delegate.reloadCollectionView()
                }
        }
        
        recommendationQuery.async()
        
    }
    
}

