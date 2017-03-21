//
//  AuthorizationCenter.swift
//  ACRouter
//
//  Created by SnowCheng on 21/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class AuthorizationCenter: NSObject {

    static let `default` = {
        AuthorizationCenter()
    }()
    
    var isLogin = false
}
