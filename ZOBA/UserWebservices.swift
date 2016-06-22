//
//  UserWebservices.swift
//  ZOBA
//
//  Created by RE Pixels on 6/11/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults
class UserWebservice
{
    var user: MyUser?
    
    var registerURL : String
    var loginURL : String
    var registerDeviceURL : String
    var registerImageURL : String
    
    init(currentUser user:MyUser)
    {
        self.user = user
        self.registerURL = ""
        self.loginURL = ""
        self.registerImageURL = ""
        self.registerDeviceURL = ""
    }
    
    private func buildRegisterURL()
    {
        registerURL = StringConstants.servicesDomain+"register?"
        registerURL += "username="+self.user!.userName!
        registerURL += "&email="+self.user!.email!
        registerURL += "&password="+self.user!.password!
        registerURL += "&firstName="+self.user!.firstName!
        registerURL += "&lastName="+self.user!.lastName!
        registerURL += "&phone=";
        
        //Clear Users in the managed context
        self.user?.release(SessionObjects.currentManageContext)
    }
    
    private func buildLoginByUserNameURL()
    {
        loginURL = StringConstants.servicesDomain+"login?"
        loginURL += "user="+self.user!.userName!
        loginURL += "&pass="+self.user!.password!
        
        //Clear Users in the managed context
        self.user?.release(SessionObjects.currentManageContext)
        
    }
    
    private func buildLoginByUserEmailURL()
    {
        loginURL = StringConstants.servicesDomain+"login/email?"
        loginURL += "email="+self.user!.email!
        loginURL += "&pass="+self.user!.password!
        
        //Clear Users in the managed context
        self.user?.release(SessionObjects.currentManageContext)
        
    }
    
    
    
    
    func registerUser (result : (user:MyUser? , code:String)->Void)
    {
        self.buildRegisterURL()
        
        Alamofire.request(.GET, self.registerURL)
            .responseJSON { response in
                switch response.result
                {
                case .Success(let _data):
                    let connectionStatus = _data["status"] as! String
                    switch connectionStatus
                    {
                    case "success":
                        if let userJSON = _data["result"] as? NSDictionary
                        {
                            let mappedUser = Mapper<MyUser>().map(userJSON)
                            
                            if(Defaults[.deviceToken] != nil)
                            {
                                mappedUser?.deviceToken = Defaults[.deviceToken]
                            }
                            
                            result(user: mappedUser,code: connectionStatus)
                            mappedUser?.release(SessionObjects.currentManageContext)
                        }
                        
                        break;
                    case "error":
                        let returnedJSON = _data["result"] as? String
                        result(user: nil,code: returnedJSON!)
                        break;
                    default:
                        result(user: nil,code: connectionStatus)
                        break;
                        
                    }
                    
                    break
                case .Failure( _):
                    let errorMessage = "We're having a tiny problem. Try loging in later!"
                    result(user: nil,code: errorMessage)
                    break
                }
                
                
        }
    }
    
    func loginUser (result: (user:MyUser? , code:String)->Void)
    {
        self.buildLoginByUserEmailURL()
        Alamofire.request(.GET, self.loginURL)
            .responseJSON { response in
                switch response.result
                {
                case .Success(let _data):
                    let connectionStatus = _data["status"] as! String
                    switch connectionStatus
                    {
                    case "success":
                        if let userJSON = _data["result"] as? NSDictionary
                        {
                            let mappedUser = Mapper<MyUser>().map(userJSON)
                            result(user: mappedUser,code: connectionStatus)
                        }
                        
                        break;
                    case "error":
                        let returnedJSON = _data["result"] as? String
                        result(user: nil,code: returnedJSON!)
                        break;
                    default:
                        result(user: nil,code: connectionStatus)
                        break;
                        
                    }
                    
                    break
                case .Failure(_):
                    let errorMessage = "We're having a tiny problem. Try loging in later!"
                    result(user: nil,code: errorMessage)
                    break
                }
                
                
        }
    }
    
    
    func saveProfilePicture(userId : Int , image : UIImage , imageExtension : String){
        
        
        
        
        let data = UIImagePNGRepresentation(image)
        
        let url = StringConstants.servicesDomain + "img"
        
        
        let base64String = data!.base64EncodedStringWithOptions([])
        
        Alamofire.request(.POST, url , parameters: ["image":base64String,"userId":userId,"fileExt":imageExtension]).response { (req, res, data, error) in
            
            print("result : \(res)")
            print("error :\(error)" )
        }
        
    }
    
    
    
}