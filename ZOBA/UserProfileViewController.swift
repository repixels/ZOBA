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
    
    var user : MyUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = user.userName! + " profile"
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        phone.enabled = false
        firstName.enabled = false
        lastName.enabled = false
        email.enabled = false
        userName.enabled = false
        print("========================")
        print(user.email)
        phone.text = (user.phone != nil) ? user.phone : ""
        firstName.text = (user.firstName != nil) ? user.firstName : ""
        lastName.text = (user.lastName != nil) ? user.lastName : ""
        email.text = (user.email != nil) ? user.email : ""
        userName.text = (user.userName != nil) ? user.userName : ""
    }
    
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "userProfileEdit")
        {
            let editView = segue.destinationViewController as! UserProfileEditController
            editView.user = user
            print("========================")
            print(user.email)
        }
    }
    
    
}
