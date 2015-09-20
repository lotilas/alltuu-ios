//
//  AtCacheManager.swift
//  
//
//  Created by MAC on 15/9/19.
//
//

import Foundation
import Haneke

class AtCacheManager {
    static let NEVER_EXPIRE = "ETERNAL"
    static let A_MINUTE:NSTimeInterval = 60
    static let AN_HOUR:NSTimeInterval = 60*60
    static let A_DAY:NSTimeInterval = 24*60*60
    static let A_WEEK:NSTimeInterval = 7*24*60*60
    
    static var formatter = NSDateFormatter()
    
    init() {
        AtCacheManager.formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        AtCacheManager.formatter.timeZone = NSTimeZone(abbreviation: "GMT")
    }
    
    func isCacheValid(key:String, returnHandler:(Bool) -> Void) {
        let cache = Shared.stringCache
        cache.fetch(key: key).onFailure{ failure in
            // no such key in cache
//            println("NO SUCH KEY:\(key  )")
            returnHandler(false)
        }.onSuccess{ string in
            if string == AtCacheManager.NEVER_EXPIRE {
//                println("ETERNAL:\(key)")
                returnHandler(true)
            } else {
                let expireDate = AtCacheManager.formatter.dateFromString(string)
                let now = NSDate()
                // still valid
                if expireDate?.compare(now) == NSComparisonResult.OrderedDescending {
//                    println("KEY VALID:\(key)")
                    returnHandler(true)
                } else {
                    // expired
//                    println("KEY EXPIRED:\(key)")
                    cache.remove(key: key)
                    returnHandler(false)
                }
            }
        }
    }
    
    func setCacheExpire(key:String, expirationIntervalFromNow:NSTimeInterval) {
        let cache = Shared.stringCache
        var now = NSDate()
        var expireDate = now.dateByAddingTimeInterval(expirationIntervalFromNow)
        let expireDateString = AtCacheManager.formatter.stringFromDate(expireDate)
        cache.set(value: expireDateString, key: key)
//        println("SET KEY:\(key)")
    }
}