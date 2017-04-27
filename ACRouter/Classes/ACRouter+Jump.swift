//
//  ACRouter+Jump.swift
//  ACRouter
//
//  Created by SnowCheng on 12/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import Foundation


//extension of viewcontroller jump for ACRouter
extension ACRouter {
    
// MARK: - Constants
    static let ACJumpTypeKey = "ACJumpTypeKey"
    public enum ACJumpType: String {
        case modal = "ACJumpTypeModal"
        case represent = "ACJumpTypeRepresent"
    }

// MARK: - Convenience method
    public class func generate(_ patternString: String, params: [String: String] = [String: String](), jumpType: ACJumpType) -> String {
        
        var urlString = patternString
        var queries = params
        
        let paths = ACRouter.parserPaths(patternString)
        paths
            .filter{$0.contains(":")}
            .forEach { conponent in
                let key = conponent.ac_dropFirst(1)
                if let value = queries[key] ,
                    let range = urlString.range(of: conponent) {
                    urlString.replaceSubrange(range, with: value)
                    queries.removeValue(forKey: key)
                }
            }
        queries[ACJumpTypeKey] = jumpType.rawValue
        
        let queryString = queries.map{ "\($0.key)=\($0.value)" }.joined(separator: "&")
        return urlString + "?" + queryString
    }

// MARK: - Public method
    public class func openURL(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) {
        
        let response = ACRouter.requestURL(urlString, userInfo: userInfo)
        let instance = response.pattern?.handle(response.queries)
        let queries = response.queries
        
        guard
            let typeString = queries[ACJumpTypeKey] as? String,
            let jumpType = ACJumpType.init(rawValue: typeString),
            let vc = instance as? UIViewController else {
            return
        }
        
        switch jumpType {
        case .modal:
            modal(vc)
        case .represent:
            push(vc)
        }
        
    }
    
    class func push(_ vc: UIViewController) {
        ac_getTopViewController(nil)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func modal(_ vc: UIViewController) {
        ac_getTopViewController(nil)?.present(vc, animated: true, completion: nil)
    }

// MARK: - Private method
    private class func ac_getTopViewController(_ currentVC: UIViewController?) -> UIViewController? {
        
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            print("rootViewController is nil")
            return nil
        }
        let topVC = currentVC ?? rootVC
        
        switch topVC {
        case is UITabBarController:
            if let top = (topVC as! UITabBarController).selectedViewController {
                return ac_getTopViewController(top)
            } else {
                return nil
            }
            
        case is UINavigationController:
            if let top = (topVC as! UINavigationController).topViewController {
                return ac_getTopViewController(top)
            } else {
                return nil
            }
            
        default:
            return topVC
        }
    }
}
