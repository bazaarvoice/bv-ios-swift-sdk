//
//  WriteReviewViewModel.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 14/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import SDForms
import BVSwift
import FontAwesomeKit

protocol WriteReviewViewModelDelegate: class {
    
    var productName: String? { get }
    
    var productRating: Double? { get }
    
    var productImageURL: URL? { get }
    
    var numberOfSections: Int { get }
    
    func numberOfFieldsInSection(_ section: Int) -> Int
    
    func titleForHeaderInSection(_ section: Int) -> String?
    
    func formFieldForRow(row: Int, inSection section: Int) -> SDFormField
    
    func submitQuestionTapped()
}

class WriteReviewViewModel: ViewModelType {
    
    private enum FieldType: Int, CaseIterable {
        
        case recommendProductSwitch
        
        case ratingStars
        
        case reviewTitle
        
        case reviewDetails
        
        case userNickname
        
        case userEmail
        
        case photo
        
        case sendEmailAlertWhenPublished
        
        var propertyKey: String {
            
            switch self {
                
            case .recommendProductSwitch: return UserFormConstants.recommendProductSwitchKey
                
            case .ratingStars: return UserFormConstants.ratingStarsKey
                
            case .reviewTitle: return UserFormConstants.reviewTitleFieldKey
                
            case .reviewDetails: return UserFormConstants.reviewDetailsFieldKey
                
            case .userNickname: return UserFormConstants.userNicknameFieldKey
                
            case .userEmail: return UserFormConstants.userEmailFieldKey
                
            case .photo: return UserFormConstants.photoKey
                
            case .sendEmailAlertWhenPublished: return UserFormConstants.sendEmailAlertWhenPublishedFieldKey
                
            }
        }
        
        var sectionTitle: String {
            
            switch self {
                
            case .recommendProductSwitch: return ""
                
            case .ratingStars: return UserFormConstants.ratingStarsTitle
                
            case .reviewTitle: return UserFormConstants.reviewTitleFieldTitle
                
            case .reviewDetails: return UserFormConstants.reviewDetailsFieldTitle
                
            case .userNickname: return UserFormConstants.userNicknameFieldTitle
                
            case .userEmail: return UserFormConstants.userEmailFieldTitle
                
            case .photo: return UserFormConstants.photoTitle
                
            case .sendEmailAlertWhenPublished: return UserFormConstants.sendEmailAlertWhenPublishedFieldTitle
                
            }
        }
        
        func sdFormField(object: Any!) -> SDFormField {
            
            switch self {
                
            case .recommendProductSwitch:
                let recommendProductSwitch = SDSwitchField(object: object,
                                                           relatedPropertyKey: self.propertyKey)!
                recommendProductSwitch.title = UserFormConstants.recommendProductSwitchText
                return recommendProductSwitch
                
            case .ratingStars:
                let ratingStars = SDRatingStarsField(object: object, relatedPropertyKey: self.propertyKey)!
                ratingStars.maximumValue = 5
                ratingStars.minimumValue = 0
                return ratingStars
                
            case .reviewTitle:
                let reviewTitleField = SDMultilineTextField(object: object, relatedPropertyKey: self.propertyKey)!
                reviewTitleField.placeholder = UserFormConstants.reviewTitleFieldText
                return reviewTitleField
                
            case .reviewDetails:
                let reviewDetailsField = SDMultilineTextField(object: object, relatedPropertyKey: self.propertyKey)!
                reviewDetailsField.placeholder = UserFormConstants.reviewDetailsFieldText
                return reviewDetailsField
                
            case .userNickname:
                let nickNameField : SDTextFormField = SDTextFormField(object: object,
                                                                      relatedPropertyKey: self.propertyKey)
                nickNameField.placeholder = UserFormConstants.userNicknameFieldText
                return nickNameField
                
            case .userEmail:
                let emailAddressField : SDTextFormField = SDTextFormField(object: object,
                                                                          relatedPropertyKey: self.propertyKey)
                emailAddressField.placeholder = UserFormConstants.userEmailFieldText
                return emailAddressField
                
            case .photo:
                let photo = SDPhotoField(object: object, relatedPropertyKey: self.propertyKey)!
                photo.presentingMode = SDFormFieldPresentingModeModal
                let cameraIcon = FAKFontAwesome.cameraIcon(withSize: 22)
                cameraIcon?.addAttribute(NSAttributedString.Key.foregroundColor.rawValue, value: UIColor.lightGray.withAlphaComponent(0.5))
                photo.callToActionImage = cameraIcon?.image(with: CGSize(width: 22, height: 22))
                return photo
                
            case .sendEmailAlertWhenPublished:
                let emailOKSwitchField = SDSwitchField(object: object,
                                                       relatedPropertyKey: self.propertyKey)!
                emailOKSwitchField.title = UserFormConstants.sendEmailAlertWhenPublishedFieldText
                return emailOKSwitchField
                
            }
            
        }
    }
    
    
    weak var viewController: WriteReviewViewControllerDelegate?
    
    var coordinator: Coordinator?
    
    private var formFields: [SDFormField] = []
    
    private let product: BVProduct
    
    private var reviewSubmissionDictionary: NSMutableDictionary = [:]
    
    init(product: BVProduct) {
        self.product = product
        self.createFormFields()
    }
    
    private func createFormFields() {
        
        for fieldType in FieldType.allCases {
            self.reviewSubmissionDictionary.setValue(nil, forKey: fieldType.propertyKey)
            self.formFields.append(fieldType.sdFormField(object: self.reviewSubmissionDictionary))
        }
        
    }
}

extension WriteReviewViewModel: WriteReviewViewModelDelegate {
    
    var productName: String? {
        return self.product.name
    }
    
    var productRating: Double? {
        return self.product.reviewStatistics?.averageOverallRating
    }
    
    var productImageURL: URL? {
        return self.product.imageUrl?.value
    }
    
    var numberOfSections: Int {
        return self.formFields.count
    }
    
    func numberOfFieldsInSection(_ section: Int) -> Int {
        return 1
    }
    
    func titleForHeaderInSection(_ section: Int) -> String? {
        return FieldType(rawValue: section)?.sectionTitle
    }
    
    func formFieldForRow(row: Int, inSection section: Int) -> SDFormField {
        return self.formFields[section]
    }
    
    func submitQuestionTapped() {
        
    }
    
}
