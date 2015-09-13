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
    public var downloaded: Bool
    public var size:CGSize
    
    init(dictionary : NSDictionary, activityId: Int) {
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
        
        self.downloaded = false;
        self.size = CGSize()
    }
    
    public func description() -> String {
        return "{\n\tid:\(id) \n\turl:\(url) \n\tdownloaded:\(downloaded)\n}"
    }
    
    public func toCacheKey() -> String {
        return "\(id).jpg"
    }
    
    public func downloadPhoto(action :(() -> Void)){
        let cache = Shared.imageCache

        let cacheKey = self.toCacheKey()
        println("start download \(self.id)")
        cache.fetch(key: cacheKey).onSuccess { image in
            self.downloaded = true
            self.size = image.size
            println("\(self.id) (From cache) :\(cacheKey)")
            action()
        }.onFailure {failer in
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)) { () -> Void in
                if let imageURL = NSURL(fileURLWithPath: self.url) {
                    if let imageData = NSData(contentsOfURL: NSURL(string: self.url)!){
                        let image = UIImage(data:imageData)
                        cache.set(value: image!, key: cacheKey)
                        self.downloaded = true
                        self.size = image!.size
                        println("\(self.id) (Downloaded) : \(cacheKey)")
                        action()
                    }
                }
            }
        }

    }
}
