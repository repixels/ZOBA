//
//  UserProfileViewController.swift
//  ZOBA
//
//  Created by Angel mas on 6/7/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import UIKit
import TextFieldEffects

class UserProfileViewController: UIViewController , UIPopoverPresentationControllerDelegate,  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var firstName: HoshiTextField!
    @IBOutlet weak var lastName: HoshiTextField!
    
    @IBOutlet weak var phone: HoshiTextField!
    
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var userName: HoshiTextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var rightBarActionButton: UIBarButtonItem!
    
    @IBOutlet var editImageButton: UIButton!
    
    @IBOutlet var initialsLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var isEditMode : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeFieldsStatus()
        
        self.loadUserImage()
        
        phone.text = (SessionObjects.currentUser.phone != nil) ? SessionObjects.currentUser.phone : " "
        firstName.text = (SessionObjects.currentUser.firstName != nil) ? SessionObjects.currentUser.firstName : " "
        lastName.text = (SessionObjects.currentUser.lastName != nil) ? SessionObjects.currentUser.lastName : " "
        email.text = (SessionObjects.currentUser.email != nil) ? SessionObjects.currentUser.email : " "
        userName.text = (SessionObjects.currentUser.userName != nil) ? SessionObjects.currentUser.userName : " "
        
        //register keyboard notification
        let notCenter = NotificationCenter.default
        notCenter.addObserver(self, selector: #selector (keyboardWillHide), name: 	NSNotification.Name.UIKeyboardWillHide, object: nil)
        notCenter.addObserver(self, selector: #selector (keyBoardWillAppear), name: 	NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.prepareNavigationBar(title: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav-background"), for: .default)
    }
    @IBAction func rightBarButtonClicked(sender: UIBarButtonItem) {
        
        if !isEditMode
        {
            isEditMode = true
            self.navigationItem.rightBarButtonItem!.title = "Save"
            self.changeFieldsStatus()
        }
        else
        {
            updateUserInformation()
            isEditMode = false
            self.navigationItem.rightBarButtonItem!.title = "Edit"
            self.changeFieldsStatus()
        }
    }
    
    
    
    //MARK: - keyboard
    func keyBoardWillAppear(notification : NSNotification){
        
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize =    (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x,y: 0 + keyboardSize.height) //set zero instead
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let _: CGSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size {
                let contentInset = UIEdgeInsets.zero
                
                
                self.scrollView.contentInset = contentInset
                self.scrollView.scrollIndicatorInsets = contentInset
                self.scrollView.contentOffset = CGPoint(x:self.scrollView.contentOffset.x,y: self.scrollView.contentOffset.y)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func changeFieldsStatus()
    {
        phone.isEnabled = isEditMode
        firstName.isEnabled = isEditMode
        lastName.isEnabled = isEditMode
        email.isEnabled = isEditMode
        userName.isEnabled = isEditMode
        editImageButton.isEnabled = !isEditMode
    }
    
    func loadUserImage()
    {
        if (SessionObjects.currentUser.image != nil)
        {
            imageView.image = UIImage(data: SessionObjects.currentUser.image!)
            initialsLabel.isHidden = true
        }
        else
        {
            var userIntials = ""
            if SessionObjects.currentUser.firstName?.characters.first != nil
            {
                userIntials.append((SessionObjects.currentUser.firstName?.characters.first)!)
                
                
                if SessionObjects.currentUser.lastName?.characters.first != nil
                {
                    
                    userIntials.append((SessionObjects.currentUser.lastName?.characters.first)!)
                }
                else
                {
                    userIntials.append((SessionObjects.currentUser.lastName?.characters.last)!)
                    
                }
            }
            initialsLabel.isHidden = false
            initialsLabel.text = userIntials.uppercased()
            
        }
    }
    
    func updateUserInformation()
    {
        SessionObjects.currentUser.phone = phone.text != nil ? phone.text  : nil
        SessionObjects.currentUser.firstName = firstName.text != nil ? firstName.text  : nil
        SessionObjects.currentUser.lastName = lastName.text != nil ? lastName.text  : nil
        SessionObjects.currentUser.email = email.text != nil ? email.text  : nil
        SessionObjects.currentUser.userName = userName.text != nil ? userName.text  : nil
        
        SessionObjects.currentUser.save()
    }
    
    @IBAction func updateUserImage(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
        
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            SessionObjects.currentUser.image = UIImagePNGRepresentation(image)
            SessionObjects.currentUser.save()
            let userWebService = UserWebservice(currentUser: SessionObjects.currentUser)
            userWebService.saveProfilePicture(userId: Int(SessionObjects.currentUser.userId!), image: image, imageExtension: "png")
            
        }
        self.loadUserImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    func prepareNavigationBar(title: String)
    {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Continuum Medium", size: 22)!]
        self.navigationController!.navigationBar.tintColor = UIColor.white;
        self.title = self.contextAwareTitle()
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        
    }
    
    func contextAwareTitle() -> String?
    {
        let now = Date()
        let cal = Calendar.current
        let comps = cal.component(Calendar.Component.hour, from: now)
        
        switch comps {
        case 0 ... 12:
            return "Good Morning"
        case 13 ... 17:
            return "Good Afternoon"
        case 18 ... 23:
            return "Good Evening"
        default:
            return "Welcome Back"
        }
    }
    
    
    
}
