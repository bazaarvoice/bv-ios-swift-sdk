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
    
    func submitReviewTapped()
    
    func submitReviewCall()
    
    func progressiveSubmissionCall()
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
                
            case .recommendProductSwitch: return UserFormConstants.ratingStarText
                
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
    
    private enum FieldValidationError: Error {
        
        case reviewTitleEmptyError
        
        case ratingEmptyError
        
        case reviewDetailEmptyError
        
        case userNicknameEmptyError
        
        case emailAddressEmptyError
        
        case emailAddressInvalidError
        
        
        var errorMessage: String {
            
            switch self {
                
            case .reviewTitleEmptyError: return ErrorMessage.reviewTitleEmptyError
                
            case .ratingEmptyError: return ErrorMessage.ratingEmptyError
                
            case .reviewDetailEmptyError: return ErrorMessage.reviewDetailEmptyError
                
            case .userNicknameEmptyError: return ErrorMessage.userNicknameEmptyError
                
            case .emailAddressEmptyError: return ErrorMessage.emailAddressEmptyError
                
            case .emailAddressInvalidError: return ErrorMessage.emailAddressInvalidError
                
            }
        }
    }
    
    
    weak var viewController: WriteReviewViewControllerDelegate?
    
    var coordinator: Coordinator?
    
    private var formFields: [SDFormField] = []
    
    private let product: BVProduct
    
    //Make it true if you want do Progressive Submission and pass your session token from ConfigurationManager -> submissionSessionToken
    private var isProgressiveSubmission: Bool = false
    
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
    
    private func validateFields() throws {
        
        guard Utils.isFieldNotEmpty(self.reviewSubmissionDictionary[FieldType.ratingStars.propertyKey]) else {
            throw FieldValidationError.ratingEmptyError
        }
        
        guard Utils.isFieldNotEmpty(self.reviewSubmissionDictionary[FieldType.reviewTitle.propertyKey]) else {
            throw FieldValidationError.reviewTitleEmptyError
        }
        
        guard Utils.isFieldNotEmpty(self.reviewSubmissionDictionary[FieldType.reviewDetails.propertyKey]) else {
            throw FieldValidationError.reviewDetailEmptyError
        }
        
        guard Utils.isFieldNotEmpty(self.reviewSubmissionDictionary[FieldType.userNickname.propertyKey]) else {
            throw FieldValidationError.userNicknameEmptyError
        }
        
        guard Utils.isFieldNotEmpty(self.reviewSubmissionDictionary[FieldType.userEmail.propertyKey]) else {
            throw FieldValidationError.emailAddressEmptyError
        }
        
        guard Utils.isValidEmail(self.reviewSubmissionDictionary[FieldType.userEmail.propertyKey] as? String) else {
            throw FieldValidationError.emailAddressInvalidError
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
    
    func submitReviewTapped() {
        do {
            
            try self.validateFields()
            
            self.isProgressiveSubmission ? self.progressiveSubmissionCall() : self.submitReviewCall()
            
        }
        catch {
            self.coordinator?.showAlert(title: ErrorMessage.validationError,
                                        message: (error as! FieldValidationError).errorMessage,
                                        handler: nil)
        }
    }
    
    func submitReviewCall() {
        
        guard let delegate = viewController else { return }
        
        let review: BVReview = BVReview(productId: self.product.productId!,
                                        reviewText: self.reviewSubmissionDictionary.value(forKey: UserFormConstants.reviewDetailsFieldKey) as? String ?? "",
                                        reviewTitle: self.reviewSubmissionDictionary.value(forKey: UserFormConstants.reviewTitleFieldKey) as? String ?? "",
                                        reviewRating: self.reviewSubmissionDictionary.value(forKey: UserFormConstants.ratingStarsKey) as? Int ?? 0)
        
        guard let reviewSubmission = BVReviewSubmission(review) else {
            return
        }
        
        if let selectedPhoto = self.reviewSubmissionDictionary.value(forKey: UserFormConstants.photoKey) as? UIImage {
            (reviewSubmission <+> .photos([BVPhoto(selectedPhoto)]))
        }
        
        let email = self.reviewSubmissionDictionary.value(forKey: UserFormConstants.userEmailFieldKey) as? String ?? ""
        
        let usLocale: Locale = Locale(identifier: User.local)
        
        (reviewSubmission
            <+> .preview // don't actually just submit for real, this is just for demo
            <+> .locale(usLocale)
            <+> .sendEmailWhenCommented(self.reviewSubmissionDictionary.value(forKey: UserFormConstants.sendEmailAlertWhenPublishedFieldKey) as? Bool ?? true)
            <+> .recommended(self.reviewSubmissionDictionary.value(forKey: UserFormConstants.recommendProductSwitchKey) as? Bool ?? true)
            <+> .sendEmailWhenPublished(self.reviewSubmissionDictionary.value(forKey: UserFormConstants.sendEmailAlertWhenPublishedFieldKey) as? Bool ?? true)
            <+> .nickname(self.reviewSubmissionDictionary.value(forKey: UserFormConstants.userNicknameFieldKey) as? String ?? "")
            <+> .email(email)
            <+> .identifier(User.id)
            )
            
            .configure(ConfigurationManager.sharedInstance.conversationsConfig)
        
        reviewSubmission
            .handler { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    delegate.hideLoadingIndicator()
                    
                    switch result {
                        
                    case let .failure(errors):
                        var errorMessage = ""
                        errors.forEach({ errorMessage += "\($0)."})
                        _ = SweetAlert().showAlert(AlertTitle.error, subTitle: errorMessage, style: .error, buttonTitle: AlertTitle.okay, action: nil)
                        
                    case .success:
                        _ = SweetAlert().showAlert(AlertTitle.success, subTitle: AlertMessage.successMessage, style: .success, buttonTitle: AlertTitle.okay, action: { (Okay) in
                            strongSelf.coordinator?.popBack()
                        })
                    }
                }
        }
        
        reviewSubmission.async()
    }
    
    func buildRequest() -> BVProgressiveReview {
        var submissionFields = BVProgressiveReviewFields()
        
        submissionFields = BVProgressiveReviewFields()
        submissionFields.rating = self.reviewSubmissionDictionary.value(forKey: UserFormConstants.ratingStarsKey) as? Int ?? 0
        submissionFields.title =  self.reviewSubmissionDictionary.value(forKey: UserFormConstants.reviewTitleFieldKey) as? String ?? ""
        submissionFields.reviewtext = self.reviewSubmissionDictionary.value(forKey: UserFormConstants.reviewDetailsFieldKey) as? String ?? ""
        submissionFields.sendEmailAlert = self.reviewSubmissionDictionary.value(forKey: UserFormConstants.sendEmailAlertWhenPublishedFieldKey) as? Bool ?? true
        submissionFields.isRecommended = self.reviewSubmissionDictionary.value(forKey: UserFormConstants.recommendProductSwitchKey) as? Bool ?? true
        
        var submission = BVProgressiveReview(productId: self.product.productId ?? "", submissionFields: submissionFields)
        submission.submissionSessionToken = ConfigurationManager.sharedInstance.submissionSessionToken
        submission.locale = User.local
        submission.userId = User.id
        submission.userEmail = self.reviewSubmissionDictionary.value(forKey: UserFormConstants.userEmailFieldKey) as? String ?? ""
        return submission
    }
    
    func progressiveSubmissionCall() {
        
        guard let delegate = viewController else { return }
        
        var progressiveReview: BVProgressiveReview = self.buildRequest()
        progressiveReview.isPreview = true // don't actually just submit for real, this is just for demo
        
        guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
            return
        }
        progressiveReviewSubmission.configure(ConfigurationManager.sharedInstance.conversationsConfig)
        
        progressiveReviewSubmission
            .handler { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    delegate.hideLoadingIndicator()
                    
                    switch result {
                        
                    case let .failure(errors):
                        var errorMessage = ""
                        errors.forEach({ errorMessage += "\($0)."})
                        _ = SweetAlert().showAlert(AlertTitle.error, subTitle: errorMessage, style: .error, buttonTitle: AlertTitle.okay, action: nil)
                        
                    case .success:
                        _ = SweetAlert().showAlert(AlertTitle.success, subTitle: AlertMessage.successMessage, style: .success, buttonTitle: AlertTitle.okay, action: { (Okay) in
                            strongSelf.coordinator?.popBack()
                        })
                    }
                }
        }
        
        progressiveReviewSubmission.async()
        
    }
}


