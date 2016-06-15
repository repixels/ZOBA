//
//  DataValidations.swift
//  ZOBA
//
//  Created by ZOBA on 5/30/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation

class DataValidations
{
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    static func isValidPhone(str:String) -> Bool {
        let phonePattern = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phonePattern)
        let result = phoneTest.evaluateWithObject(str)
        return result
        
    }
    
    static func isValidPassword(str:String) -> Bool {
        let passwordPattern = "^\\d{3}-\\d{3}-\\d{4}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordPattern)
        let result = passwordTest.evaluateWithObject(str)
        return result
        
    }
    
    static func isValidUesrName(str:String) -> Bool {
        let userNamePattern = "[a-z]{1,10}$"
        let userNameTest = NSPredicate(format:"SELF MATCHES %@", userNamePattern)
        let result = userNameTest.evaluateWithObject(str)
        return result
    }
    
    static func hasNoWhiteSpaces(str:String) -> Bool
    {
        let noWhiteSpacesPattern = "^[\\S]*$"
        let noWhiteSpaceTest = NSPredicate(format:"SELF MATCHES %@" , noWhiteSpacesPattern)
        let result = noWhiteSpaceTest.evaluateWithObject(str)
        return result
    }
    static func isValidDate(str:String) -> Bool
    {
        let datePattern = "^([1-9]\\d{0,2}(,\\d{3})*|([1-9]\\d*))(\\.\\d{2})?$"
        let datePatternTest = NSPredicate(format:"SELF MATCHES %@" , datePattern)
        let result = datePatternTest.evaluateWithObject(str)
        return result
    }
    static func isValidFloatNumber(str:String) -> Bool
    {
        let floatNumber = "^[0-9]*\\.?[0-9]*$"
        let floatNumberTest = NSPredicate(format:"SELF MATCHES %@" , floatNumber)
        let result = floatNumberTest.evaluateWithObject(str)
        return result
    }
}