//
//  Utils.swift
//  BVSwiftDemo
//
//  Created by Balkrishna Singbal on 16/07/20.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import Foundation

class Utils {
    
    class func isFieldNotEmpty(_ field: Any?) -> Bool {
        
        if let stringField = field as? String, !isFieldEmpty(stringField) {
            
            return true
        }
        
        return false
    }
    
    class func isFieldEmpty(_ field: String) -> Bool {
        return field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    class func isValidEmail(_ email: String?) -> Bool {
        
        guard let unwrappedEmail = email else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: unwrappedEmail)
    }
}
