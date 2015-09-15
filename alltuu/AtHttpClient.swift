//
//  AtHttpClient.swift
//  alltuu
//
//  Created by MAC on 15/9/14.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation
import SwiftHTTP

public class AtHttpClient {
    
    // MARK: 基础方法
    func httpGetWithURL(url:String, successHandler:(NSDictionary) -> Void) {
        var request = HTTPTask()
        println("\(url)")
        request.GET(url, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return
            }
            let data = response.responseObject as! NSData
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            successHandler(dict)
        })
    }
    
    // MARK: 活动
    // 获取活动列表
    func getActivities(type:Int, count:Int, page:Int, returnHandler:(error:Int, activities:Array<Activity>) -> Void){
        self.httpGetWithURL("http://m.alltuu.com/activities/\(type)/\(count)/\(page)", successHandler: { (dataDict:NSDictionary) in
            if let errorCode:Int = dataDict["errorCode"] as? Int{
                if errorCode != 0 {
                    returnHandler(error: errorCode, activities:Array<Activity>())
                } else {
                    var activities = [Activity]()
                    if let lists : AnyObject = dataDict["lists"]{
                        for activity in lists as! NSArray {
                            activities.append(Activity(dictionary: activity as! NSDictionary))
                        }
                    }
                    returnHandler(error: errorCode, activities:activities)
                }
            }
        })
    }
    
    // 获取划分
    func getSeperates(activityId:Int, returnHandler:(error:Int, seperates:Array<Seperate>) ->Void){
        self.httpGetWithURL("http://m.alltuu.com/activity/sep/\(activityId)", successHandler: { (dataDict:
            NSDictionary) in
            if let errorCode:Int = dataDict["errorCode"] as? Int{
                if errorCode != 0 {
                    returnHandler(error:errorCode, seperates:Array<Seperate>())
                } else {
                    var seperates = [Seperate]()
                    if let lists : NSDictionary = dataDict["lists"] as? NSDictionary{
                        if let seperateList : NSArray = lists["seps"] as? NSArray{
                            for seperate in seperateList {
                                seperates.append(Seperate(dictionary: seperate as! NSDictionary))
                            }
                        }
                    }
                    returnHandler(error: errorCode, seperates:seperates)
                }
            }
            
        })
    }
    
    //获取照片
    func getPhotos(activityId:Int, seperateId:Int, pageCount:Int, currentPage:Int, returnHandler:(error:Int, photos:Array<ActivityPhoto>) -> Void){
        self.httpGetWithURL("http://m.alltuu.com/activity/show/\(activityId)/\(seperateId)/\(pageCount)/\(currentPage)", successHandler: { (dataDict:NSDictionary) in
            if let errorCode:Int = dataDict["errorCode"] as? Int{
                if errorCode != 0 {
                    returnHandler(error:errorCode, photos:Array<ActivityPhoto>())
                } else {
                    var photos = [ActivityPhoto]()
                    if let lists : AnyObject = dataDict["lists"]{
                        let photoList = lists as! NSArray
                        for photo in photoList {
                            photos.append(ActivityPhoto(dictionary: photo as! NSDictionary, activityId:activityId, seperateId:seperateId))
                        }
                    }
                    returnHandler(error: errorCode, photos:photos)
                }
            }
        })
    }
    
    func getPhotographers(seperateId:Int, returnHandler:(error:Int, photos:Array<Photographer>) -> Void){
        self.httpGetWithURL("http://m.alltuu.com/activity/sep/pgs/\(seperateId)", successHandler: { (dataDict:NSDictionary) in
            if let errorCode:Int = dataDict["errorCode"] as? Int{
                if errorCode != 0 {
                    returnHandler(error:errorCode, photos:Array<Photographer>())
                } else {
                    var photographers = [Photographer]()
                    if let lists : AnyObject = dataDict["lists"]{
                        let photographerList = lists as! NSArray
                        for photographer in photographerList {
                            photographers.append(Photographer(dictionary: photographer as! NSDictionary))
                        }
                    }
                    returnHandler(error: errorCode, photos:photographers)
                }
            }
        })
    }
}