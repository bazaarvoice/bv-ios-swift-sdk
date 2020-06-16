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
    
    func fetchAuthorProfile()
    
    var numberOfSections: Int { get }
    
    var numberOfRows: Int { get }
    
}

class AuthorViewModel: ViewModelType {
    
    var coordinator: Coordinator?
    
    weak var viewController: AuthorViewControllerDelegate?
    
    private var bvAuthor: [BVAuthor]?
    
    private var error: Error?
    
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
        
        let authorQuery = BVAuthorQuery(authorId: ConfigurationManager.sharedInstance.authorId)
           // .configure(ConfigurationManager.sharedInstance.conversationsConfig)
            .configure(AuthorViewModel.config)
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
    
    var numberOfSections: Int {
        return 2
    }
    
    var numberOfRows: Int {
        return 10
    }
    
    
}
