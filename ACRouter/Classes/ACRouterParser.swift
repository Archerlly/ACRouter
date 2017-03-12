//
//  ACRouterParser.swift
//  ACRouter
//
//  Created by SnowCheng on 10/03/2017.
//  Copyright © 2017 Archerlly. All rights reserved.

import UIKit

protocol ACRouterParser {
    
    typealias ParserResult = (paths: [String], querys: [String: AnyObject])
    //不做转义
    static func parser(_ url: URL) -> ParserResult
    static func parserSheme(_ url: URL) -> String
    static func parserPaths(_ url: URL) -> [String]
    static func parserQuerys(_ url: URL) -> [String: AnyObject]
    //做转义
    static func parser(_ urlString: String) -> ParserResult
    static func parserSheme(_ urlString: String) -> String
    static func parserPaths(_ urlString: String) -> [String]
    static func parserQuerys(_ urlString: String) -> [String: AnyObject]
}

extension ACRouterParser {
    
    static func parser(_ url: URL) -> ParserResult {
        let paths = parserPaths(url)
        let query = parserQuerys(url)
        return (paths, query)
    }
    
    static func parserSheme(_ url: URL) -> String {
        return url.scheme ?? ""
    }
    
    static func parserPaths(_ url: URL) -> [String] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("url parser paths error")
            return [String]()
        }
        let paths = ac_parserPath(components)
        return paths
    }
    
    static func parserQuerys(_ url: URL) -> [String: AnyObject] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("url parser querys error")
            return [String: AnyObject]()
        }
        let query = ac_parserQuery(components)
        return (query as [String : AnyObject])
    }
    
    static func parser(_ urlString: String) -> ParserResult {
        let paths = parserPaths(urlString)
        let querys = parserQuerys(urlString)
        return (paths, querys)
    }
    
    static func parserSheme(_ urlString: String) -> String {
        if let url = ac_checkInvaild(urlString) {
            return url.scheme ?? ""
        }
        return ""
    }
    
    static func parserPaths(_ urlString: String) -> [String] {
        var paths = [String]()
        
        urlString.components(separatedBy: "#").forEach { componentString in
            if let url = ac_checkInvaild(componentString) {
                let result = parserPaths(url)
                paths += result
            }
        }
        return paths
    }
    
    static func parserQuerys(_ urlString: String) -> [String: AnyObject] {
        var querys = [String: AnyObject]()
        
        urlString.components(separatedBy: "#").forEach { componentString in
            if let url = ac_checkInvaild(componentString) {
                let result = parserQuerys(url)
                querys.ac_combine(result)
            }
        }
        return querys
    }
    
    ///解析Path (paths include the host)
    private static func ac_parserPath(_ components: URLComponents) -> [String] {
        
        var paths = [String]()
        
        //check host
        if let host = components.host, host.characters.count > 0 {
            paths.append(host)
        }
        
        //check path
        var path = components.path
        if path.characters.count > 0 {
            let pathComponents = path.components(separatedBy: "/").filter{ $0.characters.count > 0}
            paths += pathComponents
        }
        
        return paths
    }

    /// 解析Query
    private static func ac_parserQuery(_ components: URLComponents) -> [String: String] {
        
        guard let items = components.queryItems,
            items.count > 0 else {
            print("\(components.string ?? ""): query item count equal to zero")
            return [String: String]()
        }
        
        var querys = [String: String]()
        items.forEach { (item) in
            if let value = item.value {
                querys[item.name] = value
            } else {
                print("\(components.string ?? ""): query name = \(item.name)")
            }
        }
        
        return querys
    }
    
    /// 检查URL
    private static func ac_checkInvaild(_ urlString: String) -> URL? {
        
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let encodeString = urlString, encodeString.characters.count > 0 else {
            print("urlString is null")
            return nil
        }
        
        guard let url = URL.init(string: encodeString) else {
            print("invaild urlString to parser -> \(urlString)")
            return nil
        }
        
        return url
    }
}


extension String {
    func ac_dropFirst(_ count: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: count))
    }
    
    func ac_dropLast(_ count: Int) -> String {
        return self.substring(to: self.index(self.endIndex, offsetBy: -count))
    }
    
}

extension Dictionary where Value: AnyObject {
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
