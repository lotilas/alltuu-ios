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
    
    // 这个函数和下面一个函数 replaceImageThroughCache 的区别在于 这个函数会清空当前的图片 然后加载 后一个函数不会
    func loadImageThroughCache(url:String, placeHolder:UIImage? = nil, cacheKey:String, cacheExpire:NSTimeInterval) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if placeHolder != nil {
                self.image = placeHolder
            } else {
                self.image = nil
            }
        }
        self.replaceImageThroughCache(url, cacheKey:cacheKey, cacheExpire:cacheExpire)
    }
    
    
    // 这个函数 不会清空当前的UIImageView 等待图片下载好后替换当前图片
    func replaceImageThroughCache(url:String, cacheKey:String, cacheExpire:NSTimeInterval) {
        let cacheManager = AtCacheManager()
        let cache = Shared.imageCache
        cacheManager.isCacheValid(cacheKey, returnHandler: { result in
            if result {
                // cache valid !BUT may not exist due to LRU
                cache.fetch(key: cacheKey).onSuccess { image in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                        println("NW:\(cacheKey)")
                        self.image = image
                    }
                }.onFailure {failer in
                        // get from network
                        self.loadFromNetwork(url, cache: cache, cacheManager:cacheManager, cacheKey: cacheKey, cacheExpire:cacheExpire)
                }
            } else {
                // get from network
                self.loadFromNetwork(url, cache: cache, cacheManager:cacheManager, cacheKey: cacheKey, cacheExpire:cacheExpire)
            }
        })
    }
    
    func replaceImageThroughCacheAndDoSomething(url:String, cacheKey:String, cacheExpire:NSTimeInterval, something:(UIImage?) -> Void){
        let cacheManager = AtCacheManager()
        let cache = Shared.imageCache
        cacheManager.isCacheValid(cacheKey, returnHandler: { result in
            if result {
                // cache valid !BUT may not exist due to LRU
                cache.fetch(key: cacheKey).onSuccess { image in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        //                        println("NW:\(cacheKey)")
                        self.image = image
                        something(image)
                    }
                }.onFailure {failer in
                    // get from network
                    self.loadFromNetworkAndDoSomething(url, cache: cache, cacheManager:cacheManager, cacheKey: cacheKey, cacheExpire:cacheExpire, something:something)
                }
            } else {
                // get from network
                self.loadFromNetworkAndDoSomething(url, cache: cache, cacheManager:cacheManager, cacheKey: cacheKey, cacheExpire:cacheExpire, something:something)
            }
        })
    }
    
    
    
    func setPlaceHolderFromCache(cacheKey:String?) {
        if let ck = cacheKey{
            let cacheManager = AtCacheManager()
            let cache = Shared.imageCache
            cacheManager.isCacheValid(ck, returnHandler: { result in
                if result {
                    // cache valid !BUT may not exist due to LRU
                    cache.fetch(key: ck).onSuccess { image in
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            self.image = image
                        }
                    }
                }
            })
        }
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
    
    private func loadFromNetworkAndDoSomething(url:String, cache:Cache<UIImage>, cacheManager:AtCacheManager, cacheKey:String, cacheExpire:NSTimeInterval, something:(UIImage?) -> Void){
        // load image
        if let imageURL = NSURL(string: url) {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let q = dispatch_get_global_queue(qos, 0)
            dispatch_async(q) { () -> Void in
                if let imageData = NSData(contentsOfURL: NSURL(string: url)!){
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.image = UIImage(data: imageData)
                        something(self.image)
                    }
                    cache.set(value: UIImage(data:imageData)!, key: cacheKey)
                    cacheManager.setCacheExpire(cacheKey, expirationIntervalFromNow: cacheExpire)
                }
            }
        }
    }
}