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
    }
    
    weak var viewController: AskAQuestionViewControllerDelegate?
    
    weak var coordinator: Coordinator?
    
    private let product: BVProduct
    
    private var formFields: [SDFormField] = []
    
    private var paramsDictionary: NSMutableDictionary = [:]
    
    init(product: BVProduct) {
        self.product = product
        self.createFormFields()
    }
    
    private func createFormFields() {
        
        // set all the fields value in the dictionary
        for fieldType in FieldType.allCases {
            self.paramsDictionary.setValue(nil, forKey: fieldType.propertyKey)
        }
        
        let questionField = SDMultilineTextField(object: self.paramsDictionary,
                                                 relatedPropertyKey: FieldType.questionSummary.propertyKey)!
        questionField.placeholder = "Example: How do I get replacement bolts?"
        
        let moreDetailsField = SDMultilineTextField(object: self.paramsDictionary,
                                                    relatedPropertyKey: FieldType.questionDetails.propertyKey)!
        moreDetailsField.placeholder = "Example: I have looked at the manual and can't figure out what I'm doing wrong."
        
        let nickNameField : SDTextFormField = SDTextFormField(object: self.paramsDictionary,
                                                              relatedPropertyKey: FieldType.userNickname.propertyKey)
        nickNameField.placeholder = "Display name for the question"
        
        let emailAddressField : SDTextFormField = SDTextFormField(object: self.paramsDictionary,
                                                                  relatedPropertyKey: FieldType.userEmail.propertyKey)
        emailAddressField.placeholder = "Enter a valid email address."
        
        let emailOKSwitchField = SDSwitchField(object: self.paramsDictionary,
                                               relatedPropertyKey: FieldType.sendEmailAlertWhenPublished.propertyKey)!
        emailOKSwitchField.title = "Send me status by email?"
        
        let agreeTermsAndConditions = SDSwitchField(object: self.paramsDictionary,
                                                    relatedPropertyKey: FieldType.agreedToTermsAndConditions.propertyKey)!
        agreeTermsAndConditions.title = "Agree?"
        
        self.formFields = [questionField, moreDetailsField, nickNameField, emailAddressField, emailOKSwitchField, agreeTermsAndConditions]
        
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
