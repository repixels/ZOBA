//
//  UIViewControllerExtension.swift
//  ZOBA
//
//  Created by ZOBA on 5/30/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import Foundation


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
