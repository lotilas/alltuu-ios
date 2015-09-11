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


class ActivitiesViewController: UICollectionViewController {
    
    var activities = [[Activity]]()
    
    var currentPage = 0

    var pageCount = 12
    
    @IBOutlet var activitiesView: ActivityView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activitiesView.toLoadMoreAction( { () -> () in
            self.delay(0.5, closure: { () -> () in})
            self.delay(0.5, closure: { () -> () in
                self.more()
            })
        })
        
        self.more()

    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return activities.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities[section].count
    }
    
    private struct StoryBoard {
        static let CellReuseIdentifier = "Activity"
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ActivityCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoard.CellReuseIdentifier, forIndexPath: indexPath) as! ActivityCell
        cell.activity = activities[indexPath.section][indexPath.row]
        return cell
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
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
                    self.collectionView!.reloadData()
                }
            }

        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}


