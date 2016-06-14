//
//  UserProfileViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var firstName: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var userName: HoshiTextField!
    
    
    @IBOutlet weak var phone: HoshiTextField!
    @IBOutlet weak var lastName: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = SessionObjects.currentUser.userName! + " profile"
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        phone.enabled = false
        firstName.enabled = false
        lastName.enabled = false
        email.enabled = false
        userName.enabled = false
        
        
        phone.text = (SessionObjects.currentUser.phone != nil) ? SessionObjects.currentUser.phone : ""
        firstName.text = (SessionObjects.currentUser.firstName != nil) ? SessionObjects.currentUser.firstName : ""
        lastName.text = (SessionObjects.currentUser.lastName != nil) ? SessionObjects.currentUser.lastName : ""
        email.text = (SessionObjects.currentUser.email != nil) ? SessionObjects.currentUser.email : ""
        userName.text = (SessionObjects.currentUser.userName != nil) ? SessionObjects.currentUser.userName : ""
    }
    
    
    
}
