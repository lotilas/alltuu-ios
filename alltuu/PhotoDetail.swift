//
//  PhotoDetail.swift
//  alltuu
//
//  Created by MAC on 15/9/17.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation

public enum PhotoSize:String {
    case ORIGIN = "ORIGIN"
    case SMALL = "SMALL"
}

public class PhotoDetail {
    public let id: Int
    public let smallUrl: String
    public let url: String
    public let isLike: Int
    public let likeTimes: Int
    public let proId: Int
    public let cmtTimes:Int
    
    init(dictionary : NSDictionary){
        if let id = dictionary["id"] as? NSNumber {
            self.id = id as Int
        } else {
            self.id = 0
        }
        if let smallUrl = dictionary["smallUrl"] as? NSString {
            self.smallUrl = smallUrl as String
        } else {
            self.smallUrl = ""
        }
        if let url = dictionary["url"] as? NSString {
            self.url = url as String
        } else {
            self.url = ""
        }
        if let isLike = dictionary["isLike"] as? Int {
            self.isLike = isLike as Int
        } else {
            self.isLike = 0
        }
        if let likeTimes = dictionary["likeTimes"] as? Int {
            self.likeTimes = likeTimes as Int
        } else {
            self.likeTimes = 0
        }
        if let proId = dictionary["proId"] as? Int {
            self.proId = proId as Int
        } else {
            self.proId = 0
        }
        if let cmtTimes = dictionary["cmtTimes"] as? Int {
            self.cmtTimes = cmtTimes as Int
        } else {
            self.cmtTimes = 0
        }
    }
    
    public func toCacheKey(imgSize:PhotoSize) -> String {
        return "IMG-PHOTO-\(id)-\(imgSize.rawValue)"
    }
}