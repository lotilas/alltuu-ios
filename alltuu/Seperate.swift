//
//  Seperate.swift
//  alltuu
//
//  Created by MAC on 15/9/10.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation

public class Seperate {
    
    public let sepId: NSInteger
    public let sepName: String
    
    init(dictionary : NSDictionary){
        if let sepId = dictionary["sepId"] as? NSNumber {
            self.sepId = sepId as Int
        } else {
            self.sepId = 0
        }
        if let sepName = dictionary["sepName"] as? NSString {
            self.sepName = sepName as String
        } else {
            self.sepName = "无"
        }
    }
}
