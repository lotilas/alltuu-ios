//
//  AtHttpClient.swift
//  alltuu
//
//  Created by MAC on 15/9/14.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation
import SwiftHTTP
import Haneke

public enum PhotoDetailStatus : Int {
    case current = 0
    case previous = 1
    case next = 2
}

public class AtHttpClient {
    
    // MARK: 基础方法
    func httpGetWithURL(url:String, successHandler:(NSDictionary) -> Void) {
        var request = HTTPTask()
        //println("WITHOUT CACHE:\(url)")
        if let encodedUrl = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            request.GET(encodedUrl, parameters: nil, completionHandler: {(response: HTTPResponse) in
                if let err = response.error {
                    println("error: \(err.localizedDescription)")
                    return
                }
                let data = response.responseObject as! NSData
                let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                successHandler(dict)
            })
        }
    }
    
    // 带缓存
    func httpGetWithURLAndCache(url:String, cacheKey:String, cacheExpire:NSTimeInterval = AtCacheManager.A_DAY, successHandler:(NSDictionary?) -> Void) {
        let cache = Shared.dataCache
        let cacheManager = AtCacheManager()
        cacheManager.isCacheValid(cacheKey, returnHandler: { result in
            // cache not expired !BUT cache may be clear due to memory warning, so it may fail in some case
            if result {
                var dataDict:NSDictionary?
                cache.fetch(key: cacheKey).onSuccess{ data in
                    if let dataDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                        successHandler(dataDict)
                    }
                }.onFailure{ failure in
                    // not expire but fail to fetch it, may be remove from cache
                    self.getFromNetwork(url, cacheKey:cacheKey, cacheExpire:cacheExpire, cache:cache, cacheManager:cacheManager, successHandler:successHandler)
                }
            } else {
                // expired
                self.getFromNetwork(url, cacheKey:cacheKey, cacheExpire:cacheExpire, cache:cache, cacheManager:cacheManager, successHandler:successHandler)
            }
        })
    }
    
    private func getFromNetwork(url:String, cacheKey:String, cacheExpire:NSTimeInterval, cache:Cache<NSData>, cacheManager:AtCacheManager, successHandler:(NSDictionary?) -> Void){
        //println("FROM NETWORK:\(url)")
        var request = HTTPTask()
        if let encodedUrl = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            request.GET(encodedUrl, parameters: nil, completionHandler: {(response: HTTPResponse) in
                if let err = response.error {
                    println("error: \(err.localizedDescription)")
                    successHandler(nil)
                } else {
                    if let data = response.responseObject as? NSData {
                        cache.set(value: data, key: cacheKey)
                        cacheManager.setCacheExpire(cacheKey, expirationIntervalFromNow: cacheExpire)
                        if let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                            successHandler(dict)
                        }
                    }
                }
            })
        }
    }
    
    
    // MARK: 活动
    // 获取活动列表  WITH CACHE! for One Day
    func getActivities(type:Int, count:Int, page:Int, returnHandler:(error:Int, activities:Array<Activity>) -> Void){
        self.httpGetWithURLAndCache("http://m.alltuu.com/activities/\(type)/\(count)/\(page)", cacheKey: "ACTs-\(type)-\(count)-\(page)", successHandler: { (dataDict:NSDictionary?) in
            if let dict = dataDict {
                if let errorCode:Int = dict["errorCode"] as? Int{
                    if errorCode != 0 {
                        returnHandler(error: errorCode, activities:Array<Activity>())
                    } else {
                        var activities = [Activity]()
                        if let lists : AnyObject = dict["lists"]{
                            for activity in lists as! NSArray {
                                activities.append(Activity(dictionary: activity as! NSDictionary))
                            }
                        }
                        returnHandler(error: errorCode, activities:activities)
                    }
                }
            }
        })
    }
    
    // 获取划分 WITH CACHE! for One Hour!
    func getSeperates(activityId:Int, returnHandler:(error:Int, seperates:Array<Seperate>) ->Void){
        self.httpGetWithURLAndCache("http://m.alltuu.com/activity/sep/\(activityId)", cacheKey:"SEPs-\(activityId)", cacheExpire:AtCacheManager.AN_HOUR, successHandler: { (dataDict:
            NSDictionary?) in
            if let dict = dataDict {
                if let errorCode:Int = dict["errorCode"] as? Int{
                    if errorCode != 0 {
                        returnHandler(error:errorCode, seperates:Array<Seperate>())
                    } else {
                        var seperates = [Seperate]()
                        if let lists : NSDictionary = dict["lists"] as? NSDictionary{
                            if let seperateList : NSArray = lists["seps"] as? NSArray{
                                for seperate in seperateList {
                                    seperates.append(Seperate(dictionary: seperate as! NSDictionary))
                                }
                            }
                        }
                        returnHandler(error: errorCode, seperates:seperates)
                    }
                }
            }
            
        })
    }
    
    //获取照片 WITH CACHE! for one hour
    func getPhotos(activityId:Int, seperateId:Int, pageCount:Int, currentPage:Int, returnHandler:(error:Int, photos:Array<ActivityPhoto>) -> Void){
        self.httpGetWithURLAndCache("http://m.alltuu.com/activity/show/\(activityId)/\(seperateId)/\(pageCount)/\(currentPage)", cacheKey:"Photos-\(activityId)-\(seperateId)-\(pageCount)-\(currentPage)", cacheExpire:AtCacheManager.AN_HOUR, successHandler: { (dataDict:NSDictionary?) in
            if let dict = dataDict {
                if let errorCode:Int = dict["errorCode"] as? Int{
                    if errorCode != 0 {
                        returnHandler(error:errorCode, photos:Array<ActivityPhoto>())
                    } else {
                        var photos = [ActivityPhoto]()
                        if let lists : AnyObject = dict ["lists"]{
                            let photoList = lists as! NSArray
                            for photo in photoList {
                                photos.append(ActivityPhoto(dictionary: photo as! NSDictionary, activityId:activityId, seperateId:seperateId))
                            }
                        }
                        returnHandler(error: errorCode, photos:photos)
                    }
                }
            }
        })
    }
    
    //获取摄影师
    func getPhotographers(seperateId:Int, returnHandler:(error:Int, photos:Array<Photographer>) -> Void){
        self.httpGetWithURLAndCache("http://m.alltuu.com/activity/sep/pgs/\(seperateId)", cacheKey:"SEPPGs-\(seperateId)", cacheExpire:AtCacheManager.A_WEEK, successHandler: { (dataDict:NSDictionary?) in
            if let dict = dataDict {
                if let errorCode:Int = dict["errorCode"] as? Int{
                    if errorCode != 0 {
                        returnHandler(error:errorCode, photos:Array<Photographer>())
                    } else {
                        var photographers = [Photographer]()
                        if let lists : AnyObject = dict["lists"]{
                            let photographerList = lists as! NSArray
                            for photographer in photographerList {
                                photographers.append(Photographer(dictionary: photographer as! NSDictionary))
                            }
                        }
                        returnHandler(error: errorCode, photos:photographers)
                    }
                }
            }
        })
    }
    
    //搜索活动
    func searchActivities(keywords:String, pageCount:Int, page:Int, returnHandler:(error:Int, activities:Array<Activity>) -> Void){
        self.httpGetWithURL("http://m.alltuu.com/activities/search/\(pageCount)/\(page)/\(keywords)", successHandler: { (dataDict:NSDictionary?) in
            if let dict = dataDict {
                if let errorCode:Int = dict["errorCode"] as? Int{
                    if errorCode != 0 {
                        returnHandler(error: errorCode, activities:Array<Activity>())
                    } else {
                        var activities = [Activity]()
                        if let lists : AnyObject = dict["lists"]{
                            for activity in lists as! NSArray {
                                activities.append(Activity(dictionary: activity as! NSDictionary))
                            }
                        }
                        returnHandler(error: errorCode, activities:activities)
                    }
                }
            }
        })
    }
    
    // 查询id所指照片详情
    func getCurrentPhotoDetail(id:Int, activityId:Int, seperateId:Int, returnHandler:(error:Int, photo:PhotoDetail?) -> Void){
        self.getPhotoDetail(id, activityId: activityId, seperateId: seperateId, status: PhotoDetailStatus.current,returnHandler:returnHandler)
    }
    
    // 查询id所指照片前一张详情 可能不存在
    func getNextPhotoDetail(id:Int, activityId:Int, seperateId:Int, returnHandler:(error:Int, photo:PhotoDetail?) -> Void){
        self.getPhotoDetail(id, activityId: activityId, seperateId: seperateId, status: PhotoDetailStatus.next,returnHandler:returnHandler)
    }
    
    // 查询id所指照片前一张详情 可能不存在
    func getPreviousPhotoDetail(id:Int, activityId:Int, seperateId:Int, returnHandler:(error:Int, photo:PhotoDetail?) -> Void){
        self.getPhotoDetail(id, activityId: activityId, seperateId: seperateId, status: PhotoDetailStatus.previous,returnHandler:returnHandler)
    }
    
    // 获取照片详情
    private func getPhotoDetail(id:Int, activityId:Int, seperateId:Int, status:PhotoDetailStatus, returnHandler:(error:Int, photo:PhotoDetail?) -> Void) {
        self.httpGetWithURLAndCache("http://m.alltuu.com/photo/\(activityId)/\(seperateId)/\(id)/\(status.rawValue)", cacheKey:"PHOTO-\(activityId)-\(seperateId)-\(id)-\(status.rawValue)", cacheExpire:AtCacheManager.A_WEEK, successHandler: { (dataDict:NSDictionary?) in
            if let dict = dataDict {
                if let errorCode:Int = dict["errorCode"] as? Int{
                    if errorCode != 0 {
                        returnHandler(error: errorCode, photo:nil)
                    } else {
                        var photo:PhotoDetail?
                        if let lists : NSArray = dict["lists"] as? NSArray{
                            if lists.count > 0 {
                                if let info : NSDictionary = lists[0] as? NSDictionary{
                                    photo = PhotoDetail(dictionary: info)
                                }
                            }
                        }
                        returnHandler(error: errorCode, photo:photo)
                    }
                }
            }
        })
    }
    
    // 查询摄影师详情
    func getPhotographer(proId:Int, returnHandler:(error:Int, photographer:Photographer?) -> Void){
        self.httpGetWithURLAndCache("http://m.alltuu.com/pg/\(proId)", cacheKey:"PG-\(proId)", cacheExpire:AtCacheManager.AN_HOUR, successHandler: { (dataDict:NSDictionary?) in
            if let dict = dataDict {
                if let errorCode:Int = dict["errorCode"] as? Int{
                    var photographer:Photographer?
                    if errorCode == 0 {
                        if let lists : NSArray = dict["lists"] as? NSArray{
                            if let info : NSDictionary = lists[0] as? NSDictionary{
                                photographer = Photographer(dictionary: info)
                            }
                        }
                    }
                    returnHandler(error: errorCode, photographer:photographer)
                }
            }
        })
    }
}