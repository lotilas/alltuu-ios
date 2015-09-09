//
//  Activity.swift
//  Smashtag
//
//  Created by MAC on 15/9/8.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation

public class Activity {
    
    public let id: NSInteger
    public let addr: String
    public let adateDot: String
    public let title: String
    
    init(dictionary : NSDictionary){
        if let id = dictionary["id"] as? NSNumber {
            self.id = id as Int
        } else {
            self.id = 0
        }
        if let addr = dictionary["addr"] as? NSString {
            self.addr = addr as String
        } else {
            self.addr = "无"
        }
        if let adateDot = dictionary["adateDot"] as? NSString {
            self.adateDot = adateDot as String
        } else {
            self.adateDot = "无"
        }
        if let title = dictionary["title"] as? NSString {
            self.title = title as String
        } else {
            self.title = "无"
        }
    }
}
