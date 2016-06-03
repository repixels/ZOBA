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
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
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
}