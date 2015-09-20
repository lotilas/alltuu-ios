//
//  AtImageViewExtension.swift
//  alltuu
//
//  Created by MAC on 15/9/19.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit
import Haneke

extension UIImageView {
    func loadImageThroughCache(url:String, placeHolder:String? = nil, cacheKey:String, cacheExpire:NSTimeInterval) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.image = nil
        }
        let cacheManager = AtCacheManager()
        let cache = Shared.imageCache
        cacheManager.isCacheValid(cacheKey, returnHandler: { result in
            if result {
                // cache valid !BUT may not exist due to LRU
                cache.fetch(key: cacheKey).onSuccess { image in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.image = image
                    }
                }.onFailure {failer in
                    if placeHolder != nil {
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            self.image = UIImage(named: placeHolder!)
                        }
                    }
                    // get from network
                    self.loadFromNetwork(url, cache: cache, cacheManager:cacheManager, cacheKey: cacheKey, cacheExpire:cacheExpire)
                }
            } else {
                // get from network
                self.loadFromNetwork(url, cache: cache, cacheManager:cacheManager, cacheKey: cacheKey, cacheExpire:cacheExpire)
            }
        })
    }
    
    private func loadFromNetwork(url:String, cache:Cache<UIImage>, cacheManager:AtCacheManager, cacheKey:String, cacheExpire:NSTimeInterval){
        // load image
        if let imageURL = NSURL(string: url) {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let q = dispatch_get_global_queue(qos, 0)
            dispatch_async(q) { () -> Void in
                if let imageData = NSData(contentsOfURL: NSURL(string: url)!){
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.image = UIImage(data: imageData)
                    }
                    cache.set(value: UIImage(data:imageData)!, key: cacheKey)
                    cacheManager.setCacheExpire(cacheKey, expirationIntervalFromNow: cacheExpire)
                }
            }
        }
    }
}