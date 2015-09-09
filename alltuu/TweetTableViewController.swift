//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by MAC on 15/9/7.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit
import SwiftHTTP

class ActivityCollectionViewController: UICollectionViewController {

    var activities = [[Activity]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("did load")
        refresh()
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
    
    func refresh(){
        self.activities.removeAll()
        var request = HTTPTask()
        println("\(NSDate())perform http get")
        request.GET("http://m.alltuu.com/activities/0/12/1", parameters: nil, completionHandler: {(response: HTTPResponse) in
            println("\(NSDate())perform http return")
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
                self.activities.insert(array , atIndex:0)
                println("\(NSDate())start reloadData")
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.collectionView!.reloadData()
                    println("\(NSDate())end reloadData")
                }
            }
        })
    }
}
