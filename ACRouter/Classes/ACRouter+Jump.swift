//
//  ACRouter+Jump.swift
//  ACRouter
//
//  Created by SnowCheng on 12/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.
//

import UIKit

extension ACRouter {
// MARK: - Constants
    static let ACJumpTypeKey = "ACJumpTypeKey"
    enum ACJumpType: String {
        case modal = "ACJumpTypeModal"
        case represent = "ACJumpTypeRepresent"
    }

// MARK: - Convenience method
    class func generate(_ patternString: String, userInfo: [String: String] = [String: String](), jumpType: ACJumpType) -> String {
        
        var urlString = patternString
        var querys = userInfo
        
        let paths = ACRouter.parserPaths(patternString)
        paths
            .filter{$0.contains(":")}
            .forEach { conponent in
                let key = conponent.ac_dropFirst(1)
                if let value = querys[key] ,
                    let range = urlString.range(of: conponent) {
                    urlString.replaceSubrange(range, with: value)
                    querys.removeValue(forKey: key)
                }
            }
        querys[ACJumpTypeKey] = jumpType.rawValue
        
        let queryString = querys.map{ "\($0.key)=\($0.value)" }.joined(separator: "&")
        return urlString + "?" + queryString
    }

    
// MARK: - Public method
    class func openUrl(_ urlString: String, userInfo: [String: AnyObject] = [String: AnyObject]()) {
        
        let responce = ACRouter.requestUrl(urlString, userInfo: userInfo)
        let querys = responce.querys
        
        guard
            let typeString = querys[ACJumpTypeKey] as? String,
            let jumpType = ACJumpType.init(rawValue: typeString) else {
            return
        }
        
        switch jumpType {
        case .modal:
            jumpUrl_modal(responce)
        case .represent:
            jumpUrl_present(responce)
        }
        
    }
    
    class func jumpUrl_modal(_ response: RouteResponse) {
        let instance = response.pattern?.handle(response.querys)
        guard let vc = instance as? UIViewController else {
            return
        }
        ac_getTopViewController(nil)?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func jumpUrl_present(_ response: RouteResponse) {
        let instance = response.pattern?.handle(response.querys)
        guard let vc = instance as? UIViewController else {
            return
        }
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
