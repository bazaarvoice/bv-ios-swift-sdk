//
//  AskAQuestionViewModel.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 14/07/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSwift
import SDForms

protocol AskAQuestionViewModelDelegate: class {
    
    var productName: String? { get }
    
    var productRating: Double? { get }
    
    var productImageURL: URL? { get }
    
    var numberOfSections: Int { get }
    
    func numberOfFieldsInSection(_ section: Int) -> Int
    
    func titleForHeaderInSection(_ section: Int) -> String?
    
    func formFieldForRow(row: Int, inSection section: Int) -> SDFormField
    
    func submitQuestionTapped()
}

class AskAQuestionViewModel: ViewModelType {
    
    private enum FieldType: Int, CaseIterable {
        
        case questionSummary
        
        case questionDetails
        
        case userNickname
        
        case userEmail
        
        case sendEmailAlertWhenPublished
        
        case agreedToTermsAndConditions
        
        var propertyKey: String {
            
            switch self {
                
            case .questionSummary: return "questionSummary"
                
            case .questionDetails: return "questionDetails"
                
            case .userNickname: return "userNickname"
                
            case .userEmail: return "userEmail"
                
            case .sendEmailAlertWhenPublished: return "sendEmailAlertWhenPublished"
                
            case .agreedToTermsAndConditions: return "agreedToTermsAndConditions"
                
            }
        }
        
        var sectionTitle: String {
            
            switch self {
                
            case .questionSummary: return "Question"
                
            case .questionDetails: return "More Details (optional)"
                
            case .userNickname: return "Nickname"
                
            case .userEmail: return "Email address"
                
            case .sendEmailAlertWhenPublished: return "May we contact you at this email address?"
                
            case .agreedToTermsAndConditions: return "Do you agree to the Terms & Conditions?"
                
            }
        }
        
        func sdFormField(object: Any!) -> SDFormField {
            
            switch self {
                
            case .questionSummary:
                let questionField = SDMultilineTextField(object: object, relatedPropertyKey: self.propertyKey)!
                questionField.placeholder = "Example: How do I get replacement bolts?"
                return questionField
                
            case .questionDetails:
                let moreDetailsField = SDMultilineTextField(object: object, relatedPropertyKey: self.propertyKey)!
                moreDetailsField.placeholder = "Example: I have looked at the manual and can't figure out what I'm doing wrong."
                return moreDetailsField
                
            case .userNickname:
                let nickNameField : SDTextFormField = SDTextFormField(object: object,
                                                                      relatedPropertyKey: self.propertyKey)
                nickNameField.placeholder = "Display name for the question"
                return nickNameField
                
            case .userEmail:
                let emailAddressField : SDTextFormField = SDTextFormField(object: object,
                                                                          relatedPropertyKey: self.propertyKey)
                emailAddressField.placeholder = "Enter a valid email address."
                return emailAddressField
                
            case .sendEmailAlertWhenPublished:
                let emailOKSwitchField = SDSwitchField(object: object,
                                                       relatedPropertyKey: self.propertyKey)!
                emailOKSwitchField.title = "Send me status by email?"
                return emailOKSwitchField
                
            case .agreedToTermsAndConditions:
                let agreeTermsAndConditions = SDSwitchField(object: object,
                                                            relatedPropertyKey: self.propertyKey)!
                agreeTermsAndConditions.title = "Agree?"
                return agreeTermsAndConditions
            }
            
        }
    }
    
    weak var viewController: AskAQuestionViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private let product: BVProduct
    
    private var formFields: [SDFormField] = []
    
    private var questionSubmissionDictionary: NSMutableDictionary = [:]
    
    init(product: BVProduct) {
        self.product = product
        self.createFormFields()
    }
    
    private func createFormFields() {
        
        for fieldType in FieldType.allCases {
            self.questionSubmissionDictionary.setValue(nil, forKey: fieldType.propertyKey)
            self.formFields.append(fieldType.sdFormField(object: self.questionSubmissionDictionary))
        }
        
        
        
        
    }
}

// MARK:- AskAQuestionViewModelDelegate methods
extension AskAQuestionViewModel: AskAQuestionViewModelDelegate {
    
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
