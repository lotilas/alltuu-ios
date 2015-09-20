//
//  Seperate.swift
//  alltuu
//
//  Created by MAC on 15/9/10.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation
import Haneke

public class Photographer {
    
    public let id: Int
    public let name: String
    public let url: String
    public let sub: String      // 二级域名
    public let dsc: String      // 描述
    
    init(dictionary : NSDictionary) {
        if let id = dictionary["id"] as? NSNumber {
            self.id = id as Int
        } else {
            self.id = 0
        }
        if let name = dictionary["name"] as? NSString {
            self.name = name as String
        } else {
            self.name = ""
        }
        if let url = dictionary["url"] as? NSString {
            self.url = url as String
        } else {
            self.url = ""
        }
        if let sub = dictionary["sub"] as? NSString {
            self.sub = sub as String
        } else {
            self.sub = ""
        }
        if let dsc = dictionary["dsc"] as? NSString {
            self.dsc = dsc as String
        } else {
            self.dsc = ""
        }
    }
    
    public func description() -> String {
        return "{\n\tid:\(id) \n\tname:\(name) \n\turl:\(url) \n\tsub:\(sub)\n}"
    }
    
    public func toCacheKey() -> String {
        return "IMG-PG-\(id)"
    }
}
