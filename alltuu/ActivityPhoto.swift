//
//  Seperate.swift
//  alltuu
//
//  Created by MAC on 15/9/10.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation
import Haneke

public class ActivityPhoto{
    
    public let id: Int
    public let url: String
    public let activityId: Int
    public let seperateId:Int
    public var downloaded: Bool
    public var size:CGSize
    
    init(dictionary : NSDictionary, activityId: Int, seperateId:Int) {
        if let id = dictionary["id"] as? NSNumber {
            self.id = id as Int
        } else {
            self.id = 0
        }
        if let url = dictionary["url"] as? NSString {
            self.url = url as String
        } else {
            self.url = "无"
        }
        self.activityId = activityId
        self.seperateId = seperateId
        
        self.downloaded = false;
        self.size = CGSize()
    }
    
    public func description() -> String {
        return "{\n\tid:\(id) \n\turl:\(url) \n\tdownloaded:\(downloaded)\n}"
    }
    
    public func toCacheKey() -> String {
        return "IMG-PHOTO-\(id)"
    }
}
