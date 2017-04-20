//
//  ACCommonExtension.swift
//  Pods
//
//  Created by SnowCheng on 14/03/2017.
//
//

import Foundation

extension String {
    public func ac_dropFirst(_ count: Int) -> String {
//        String.init(describing: utf8.dropFirst(count))
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    public func ac_dropLast(_ count: Int) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
    
    public func ac_matchClass() -> AnyClass?{
        
        if  var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            
            if appName == "" {
                appName = ((Bundle.main.bundleIdentifier!).characters.split{$0 == "."}.map { String($0) }).last ?? ""
            }
            
            var clsStr = self
            
            if !clsStr.contains("\(appName)."){
                clsStr = appName + "." + clsStr
            }
            
            let strArr = clsStr.components(separatedBy: ".")
            
            var className = ""
            
            let num = strArr.count
            
            if num > 2 || strArr.contains(appName) {
                var nameStringM = "_TtC" + String(repeating: "C", count: num - 2)
                
                for (_, s): (Int, String) in strArr.enumerated(){
                    
                    nameStringM += "\(s.characters.count)\(s)"
                }
                
                className = nameStringM
                
            } else {
                
                className = clsStr
            }
            
            return NSClassFromString(className)
        }
        
        return nil;
    }
}

extension Dictionary {
    mutating func ac_combine(_ dict: Dictionary) {
        var tem = self
        dict.forEach({ (key, value) in
            if let existValue = tem[key] {
                //combine same name query
                if let arrValue = existValue as? [Value] {
                    tem[key] = (arrValue + [value]) as? Value
                } else {
                    tem[key] = ([existValue, value]) as? Value
                }
            } else {
                tem[key] = value
            }
        })
        self = tem
    }
}
