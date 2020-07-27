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
    var adImageArrary: [UIImage?] { get }
    func productForItemAtIndexPath(_ indexPath: IndexPath) -> BVRecommendationsProduct?
    func didSelectItemAt (indexPath: IndexPath)
    func loadProductRecommendations()
    func devInfo()
}

class HomeViewModel: ViewModelType {
    
    weak var viewController: HomeCollectionViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private var bVRecommendationsProduct: [BVRecommendationsProduct]?
    
}

extension HomeViewModel: HomeViewModelDelegate {
    
    func devInfo() {
        self.coordinator?.showAlert(title: AlertTitle.note, message: AlertMessage.launchAlertMessage, handler: nil)
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var adImageArrary: [UIImage?] {
        return [
            UIImage(named: "slide_1.jpg"),
            UIImage(named: "slide_2.jpg"),
            UIImage(named: "slide_3.jpg")
        ]
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
            .handler { [weak self] response in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    delegate.hideLoadingIndicator()
                    
                    if case let .failure(error) = response {
                        let errorMessage = (error.first as? BVError)?.message ?? "Something went wrong."
                        strongSelf.coordinator?.showAlert(title: "", message: errorMessage, handler: nil)
                        return
                    }
                    
                    guard case let .success(_, result) = response else {
                        strongSelf.coordinator?.showAlert(title: "", message: "Something went wrong.", handler: nil)
                        return
                    }
                    
                    strongSelf.bVRecommendationsProduct = result.first?.products
                    
                    delegate.reloadCollectionView()
                }
        }
        
        recommendationQuery.async()
        
    }
    
}

