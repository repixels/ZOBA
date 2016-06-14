//
//  UserDefaultsMapping.swift
//  ZOBA
//
//  Created by RE Pixels on 6/11/16.
//  Copyright © 2016 RE Pixels. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let useremail = DefaultsKey<String?>("useremail")
    static let launchCount = DefaultsKey<Int>("launchCount")
    static let isLoggedIn = DefaultsKey<Bool>("isloggedin")
    static let isFBLogin = DefaultsKey<Bool>("fblogin")
    static let deviceToken = DefaultsKey<String?>("deviceToken")
}