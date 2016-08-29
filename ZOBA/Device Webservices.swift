//
//  Device Webservices.swift
//  ZOBA
//
//  Created by RE Pixels on 6/14/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

class DeviceWebservice {
    
    var user:MyUser
    var deviceToken : String
    var registerDeviceURL : String
    
    init(deviceToken: String , currentUser: MyUser)
    {
        self.user = currentUser
        self.deviceToken = deviceToken
        registerDeviceURL = ""
    }
    
    private func buildRegisterDeviceURL()
    {
        registerDeviceURL = StringConstants.servicesDomain+"device/add?"
        registerDeviceURL += "userId="+(self.user.userId!.stringValue)
        registerDeviceURL += "&token="+(self.user.deviceToken)!
        print(registerDeviceURL)
    }
    
    func registerUserDevice()
    {
        self.buildRegisterDeviceURL()
        Alamofire.request(.GET, self.registerDeviceURL)
            .responseJSON { response in
                switch response.result
                {
                case .Success(let _data):
                    let connectionStatus = _data["status"] as! String
                    switch connectionStatus
                    {
                        case "success":
                            print(_data)
                            break;
                        case "error":
                            print(_data)
                            break;
                        default:
                            print(_data)
                            break;
                        
                    }
                    break;
                case .Failure(let _error):
                    print(_error)
                    break;
                }
                
        }

    }
    
    
}