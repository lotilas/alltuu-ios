//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by MAC on 15/9/7.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit
import SwiftHTTP
import Haneke

enum RefreshStatus{
    case Normal, Refresh, LoadMore
}

enum HeaderViewRefreshAnimationStatus{
    case headerViewRefreshPullAnimation, headerViewRefreshLoadingAnimation
}

var refreshStatus:RefreshStatus = .Normal
var tableViewOriginContentInset:UIEdgeInsets = UIEdgeInsetsZero


class ActivitiesViewController: AtViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate{
    
    var activities = [[Activity]]()
    
    var currentPage = 0

    var pageCount = 12
    
    @IBOutlet var activitiesView: ActivityView! {
        didSet {
            activitiesView.delegate = self
            activitiesView.dataSource = self
        }
    }
        
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.userInteractionEnabled = false
            var responderView = UIButton(frame: searchBar.frame)
            responderView.addTarget(self, action: "onSearchFieldClick", forControlEvents: UIControlEvents.TouchUpInside)
            searchBar.superview?.addSubview(responderView)
            self.activitiesView.backgroundColor = UIColor(colorString: "#F0F0F0")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activitiesView.initLoadMoreFootView( { () -> () in
            self.delay(0.5, closure: { () -> () in})
            self.delay(0.5, closure: { () -> () in
                self.getActivites()
            })
            }, noMoreText:"没有更多活动啦~")
        
        self.clearCacheForTest()
        
        self.getActivites()
    }
    
    private func clearCacheForTest(){
        println("clear cached")
        let ic = Shared.imageCache
        let sc = Shared.stringCache
        let dc = Shared.dataCache
        ic.removeAll()
        sc.removeAll()
        dc.removeAll()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationView!.setTitle("活动")
    }
    
    // MARK: - CollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return activities.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities[section].count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AtIdentifies.ActivityCell.rawValue, forIndexPath: indexPath) as! ActivityCell
        cell.activity = activities[indexPath.section][indexPath.row]
        return cell
    }
    
    // MARK: - CollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        println("点击了\(indexPath.section)的第\(indexPath.item)个")
    }
    
    func getActivites(){
        currentPage++
        AtHttpClient().getActivities(Activity.ActivityStatus.ONLINE.rawValue, count: pageCount, page: currentPage, returnHandler:{ (error:Int, activities:Array<Activity>) in
            self.activities.append(activities)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activitiesView.showFootView()
                if activities.count < self.pageCount {
                    self.activitiesView.didLoadAll()
                } else {
                    self.activitiesView.didLoadMore()
                }
                self.activitiesView!.reloadData()
            }
        })
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let cell = sender as? ActivityCell {
            if !cell.activity!.needPassword {
                return true
            }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? ActivityCell {
            if let destCtrler = segue.destinationViewController as? ActivityPhotosViewController{
                destCtrler.activityId = cell.activity!.id
                destCtrler.activityTitle = cell.activity!.title
            }
        }
    }
    
    func onSearchFieldClick(){
        performSegueWithIdentifier("ToActivitySearch", sender: searchBar)
    }
    
}


