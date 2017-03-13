//
//  ACRouter+Convenience.swift
//  Pods
//
//  Created by SnowCheng on 13/03/2017.
//
//

import UIKit

public extension ACRouter {
    
    public class func addRouter(_ dictionary: [String: String]) {
        dictionary.forEach { (key: String, value: String) in
            addRouter(key, classString: value)
        }
    }
    
    public class func addRouter(_ patternString: String, classString: String) {
        let clz: AnyClass? = classString.ac_matchClass()
        if let routerable = clz as? ACRouterable.Type {
            self.addRouter(patternString, handle: routerable.registerAction)
        } else {
            print("register router error: \(patternString)")
        }
    }
    
    public class func addRouter(_ patternString: String, priority: uint = 0, handle: @escaping ACRouterPattern.HandleBlock) {
        shareInstance.addRouter(patternString, priority: priority, handle: handle)
    }
    
    public class func removeRouter(_ patternString: String) {
        shareInstance.removeRouter(patternString)
    }
    
    public class func canOpenUrl(_ urlString: String) -> Bool {
        return shareInstance.canOpenUrl(urlString)
    }
    
    public class func requestUrl(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) -> RouteResponse {
        return shareInstance.requestUrl(urlString, userInfo: userInfo)
    }
}
