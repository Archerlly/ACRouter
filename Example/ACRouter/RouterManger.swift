//
//  RouterManger.swift
//  ACRouter
//
//  Created by SnowCheng on 13/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ACRouter

// 这并不是最佳实践

class RouterManger: NSObject {

    //方式一: 网络下发 URL 与 viewcontroller 的映射关系
    class func testLoadRomoteRegister() {
        let registerDict = ["AA://bb/cc/:p1" : "ErrorPageViewController"]
        ACRouter.addRouter(registerDict)
    }
    
    //方式二: 本地固定映射关系 使用枚举便于使用
    class func testLoadLocalRegister() {
        let login = LoginAPI()
        ACRouter.addRouter(login.patternString, classString: login.routerClass)
        
        let profile = ProfileAPI()
        ACRouter.addRouter(profile.patternString, classString: profile.routerClass)
    }

    /*
     学习Moya管理API的方式, 通过枚举确实方便了使用, 使各个模块的配置信息, 以及PatternURL统一管理了, 避免了将各个模块的URL散落在业务代码之中.
     但是统一管理带来的弊端就是建立了间接的耦合, Login与Profile这两个模块又与Manger耦合上了, 与Router最初的解耦思想有点背道而驰.
     至于具体是使用Enum还是直接在项目中使用URL, 大家仁者见仁智者见智, 这里只是提供一个简单的demo, 并非最佳实例
     */
    
    //测试拦截器
    class func testAddInterceptor() {
        let whitePatternString = LoginAPI().patternString
        let normal = "AA://bb/cc/:p1"
        ACRouter.addInterceptor([whitePatternString, normal], priority: 0) { (info) -> Bool in
            if AuthorizationCenter.default.isLogin {
                return true
            } else {
                ACRouter.openURL(LoginAPI().requiredURL)
                return false
            }
        }
    }
    
    //添加跳转错误回调
    class func testAddFailedAction() {
        ACRouter.addGlobalMatchFailedHandel { (info) in
            let url = ACRouter.generate("AA://bb/cc/error", jumpType: ACRouter.ACJumpType.modal)
            ACRouter.openURL(url, userInfo: info)
        }
    }
}



//统一管理各模块的配置信息
//enum localRouterable: customRouterInfo {
//    case login(username: String, password: String)
//    case profile(content: String)
//}
//
//extension localRouterable {
//    
//    var patternString: String {
//        switch self {
//        case .login:    return "ACSheme://login"
//        case .profile:  return "ACSheme://profile/:content"
//        }
//    }
//    
//    var routerClass: String {
//        switch self {
//        case .login:    return "LoginViewController"
//        case .profile:  return "ProfileViewController"
//        }
//    }
//    
//    var params: [String : String] {
//        switch self {
//        case .login(let u, let p):
//            return ["username": u, "password": p]
//        case .profile(let c):
//            return ["content": c]
//        }
//    }
//    
//    var jumpType: ACRouter.ACJumpType {
//        switch self {
//        case .login:    return ACRouter.ACJumpType.modal
//        case .profile:  return ACRouter.ACJumpType.represent
//        }
//    }
//    
//    var requiredURL: String {
//        return ACRouter.generate(self.patternString, params: self.params, jumpType: self.jumpType)
//    }
//}


protocol customRouterInfo {
    var patternString:  String { get }
    var routerClass:    String { get }
    var requiredURL:    String { get }
    var params:         [String: String] { get }
    var jumpType:       ACRouter.ACJumpType { get }
}

extension customRouterInfo {
    var requiredURL: String {
        return ACRouter.generate(self.patternString, params: self.params, jumpType: self.jumpType)
    }
}

class LoginAPI : customRouterInfo {
    
    var patternString = "ACSheme://login"
    var routerClass = "LoginViewController"
    var params: [String : String] { return ["username": name, "password": passWord] }
    var jumpType: ACRouter.ACJumpType = .represent
    
    let name: String
    let passWord: String
    init(_ name: String = "", passWord: String = "") {
        self.name = name
        self.passWord = passWord
    }
}

class ProfileAPI : customRouterInfo {
    
    var patternString = "ACSheme://profile/:content"
    var routerClass = "ProfileViewController"
    var params: [String : String] { return ["content": content] }
    var jumpType: ACRouter.ACJumpType = .modal
    
    let content: String
    init(_ content: String = "") {
        self.content = content
    }
}
