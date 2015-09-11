//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by MAC on 15/9/7.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit
import SwiftHTTP

enum RefreshStatus{
    case Normal, Refresh, LoadMore
}

enum HeaderViewRefreshAnimationStatus{
    case headerViewRefreshPullAnimation, headerViewRefreshLoadingAnimation
}

var refreshStatus:RefreshStatus = .Normal
var tableViewOriginContentInset:UIEdgeInsets = UIEdgeInsetsZero


class ActivitiesViewController: AtViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var activities = [[Activity]]()
    
    var currentPage = 0

    var pageCount = 12
    
    @IBOutlet var activitiesView: ActivityView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
//         NSThread.sleepForTimeInterval(3.0)//延长3秒
        
        self.activitiesView.dataSource = self
        self.activitiesView.delegate = self
        self.activitiesView.toLoadMoreAction( { () -> () in
            self.delay(0.5, closure: { () -> () in})
            self.delay(0.5, closure: { () -> () in
                self.more()
            })
        })
        
        self.more()

    }
    
    private struct StoryBoard {
        static let CellReuseIdentifier = "Activity"
    }
    
    // MARK: - CollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return activities.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities[section].count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoard.CellReuseIdentifier, forIndexPath: indexPath) as! ActivityCell
        cell.activity = activities[indexPath.section][indexPath.row]
        return cell
    }
    
    // MARK: - CollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        println("点击了\(indexPath.section)的第\(indexPath.item)个")
    }
    
   

    
    func more(){
        var request = HTTPTask()
        currentPage++
//        println("\(currentPage)")
        request.GET("http://m.alltuu.com/activities/0/\(pageCount)/\(currentPage)", parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return
            }
            let data = response.responseObject as! NSData
//            println("\(NSString(data:data, encoding:NSUTF8StringEncoding))")
            
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            var array = [Activity]()
            if let lists : AnyObject = dict["lists"]{
                let l = lists as! NSArray
                for act in l {
                    array.append(Activity(dictionary: act as! NSDictionary))
                }
                self.activities.append(array)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if array.count < self.pageCount {
                        self.activitiesView.didLoadAll()
                    } else {
                        self.activitiesView.didLoadMore()
                    }
                    self.activitiesView!.reloadData()
                }
            }

        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? ActivityCell {
            if let destCtrler = segue.destinationViewController as? ActivityPhotosViewController{
                destCtrler.activityId = cell.activity!.id
            }
        }
    }
}


