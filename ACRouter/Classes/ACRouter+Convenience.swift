//
//  ACRouter+Convenience.swift
//  Pods
//
//  Created by SnowCheng on 13/03/2017.
//
//

import UIKit

public extension ACRouter {
    
    /// addRouter with parasing the dictionary, the class which match the className need inherit the protocol of ACRouterable
    ///
    /// - Parameter dictionary: [patternString: className]
    public class func addRouter(_ dictionary: [String: String]) {
        dictionary.forEach { (key: String, value: String) in
            addRouter(key, classString: value)
        }
    }
    
    /// convienience addrouter with className
    ///
    /// - Parameters:
    ///   - patternString: register urlstring
    ///   - classString: the class which match the className need inherit the protocol of ACRouterable
    public class func addRouter(_ patternString: String, classString: String) {
        let clz: AnyClass? = classString.ac_matchClass()
        if let routerable = clz as? ACRouterable.Type {
            self.addRouter(patternString, handle: routerable.registerAction)
        } else {
            print("register router error: \(patternString)")
        }
    }
    
    
    /// addRouter
    ///
    /// - Parameters:
    ///   - patternString: register urlstring
    ///   - priority: match priority, sort by inverse order
    ///   - handle: block of refister URL
    public class func addRouter(_ patternString: String, priority: uint = 0, handle: @escaping ACRouterPattern.HandleBlock) {
        shareInstance.addRouter(patternString, priority: priority, handle: handle)
    }
    
    
    /// removeRouter by register urlstring
    ///
    /// - Parameter patternString: register urlstring
    public class func removeRouter(_ patternString: String) {
        shareInstance.removeRouter(patternString)
    }
    
    
    /// Check whether register for url
    ///
    /// - Parameter urlString: real request urlstring
    /// - Returns: whether register
    public class func canOpenURL(_ urlString: String) -> Bool {
        return shareInstance.canOpenURL(urlString)
    }
    

    /// request for url
    ///
    /// - Parameters:
    ///   - urlString: real request urlstring
    ///   - userInfo: custom userInfo, could contain Object
    /// - Returns: response for request, contain pattern and queries
    public class func requestURL(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) -> RouteResponse {
        return shareInstance.requestURL(urlString, userInfo: userInfo)
    }
}
