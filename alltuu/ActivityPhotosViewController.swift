//
//  ViewController.swift
//  LSFlowView
//
//  Created by  tsou117 on 15/7/6.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

import UIKit
import SwiftHTTP
import Haneke

class ActivityPhotosViewController: AtViewController, UICollectionViewDelegate,UICollectionViewDataSource,WaterFallLayoutDelegate,ActivityPhotoZoomingViewDelegate {
    
    var layout: ActivityPhotosViewLayout?
    
    
    @IBOutlet weak var waterfallView: ActivityPhotosView!
    
    var pageCount = 12
    var currentPage = 0
    var activityId = 0
    var activityTitle :String?
    var currentSepId = 0
    
    var seperates = [[Seperate]]()
    var photos = [[ActivityPhoto]]()
    
    //相对位置
    var content_y =  CGFloat()
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        
        layout = ActivityPhotosViewLayout()
        layout!.delegate = self
        
        //waterfallView
        
        waterfallView.setCollectionViewLayout(layout!, animated: true)
        waterfallView.delegate = self
        waterfallView.dataSource = self
        
        self.waterfallView.toLoadMoreAction( { () -> () in
            self.delay(0.5, closure: { () -> () in})
            self.delay(0.5, closure: { () -> () in
                self.getSep()
            })
        })
        
        self.getSep()
        
        
        
    }
    
    //UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        println("\(photos.count)")
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        println("\(photos[section].count)")
        return photos[section].count
    }

    func collectionView(collectionview: UICollectionView, layout: UICollectionViewLayout, indexPath: NSIndexPath) -> CGSize {
        let cache = Shared.imageCache
        //
        let item_w = (collectionview.frame.size.width-8)*0.5
        
        return CGSizeMake(item_w, item_w)
    }
    
    private struct StoryBoard{
        static let CellReuseIdentifier = "ActivityPhoto"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoard.CellReuseIdentifier, forIndexPath: indexPath) as! ActivityPhotoCell
        
        cell.photo = self.photos[indexPath.section][indexPath.item
        ]
        
        return cell
    }
    
    
    
    //UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ActivityPhotoCell
        cell.photoView.hidden = true
        
        var baseframe = CGRectMake(cell.frame.origin.x, cell.frame.origin.y-content_y, cell.frame.size.width, cell.frame.size.height)
        
        var zoomv = ActivityPhotoZoomingView(baseframe: baseframe)
        zoomv.delegate = self
        zoomv.setCurrImg(cell.photoView.image!)
        zoomv.show()
        
        zoomv.blockClose = {(done:Bool) -> Void in
            cell.photoView.hidden = false
        }
    }
    
    //LSImgZoomViewDelegate
    func lsImgZoomView(close: Bool) {
        //
        if (close){
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        content_y = scrollView.contentOffset.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSep(){
        if activityId > 0 {
            currentPage++
            var request = HTTPTask()
            request.GET("http://m.alltuu.com/activity/sep/\(activityId)", parameters: nil, completionHandler: {(response: HTTPResponse) in
                if let err = response.error {
                    println("error: \(err.localizedDescription)")
                    return
                }
                let data = response.responseObject as! NSData
                let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                var array = [Seperate]()
                if let lists : NSDictionary = dict["lists"] as? NSDictionary{
                    if let seps : NSArray = lists["seps"] as? NSArray{
                        for sep in seps {
                            array.append(Seperate(dictionary: sep as! NSDictionary))
                        }
                        self.seperates.append(array)
//                        println("DID LOAD \(array.count) Seps")
                        self.currentSepId = array[0].sepId
                        self.more()
                        self.loadSepSelector()
                    }
                }
            })
        }
    }
    
    func loadSepSelector(){
        
    }
    
    func more(){
        if activityId > 0 {
            currentPage++
            var request = HTTPTask()
            request.GET("http://m.alltuu.com/activity/show/\(activityId)/\(currentSepId)/\(pageCount)/\(currentPage)", parameters: nil, completionHandler: {(response: HTTPResponse) in
                if let err = response.error {
                    println("error: \(err.localizedDescription)")
                    return
                }
                let data = response.responseObject as! NSData
                let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                var array = [ActivityPhoto]()
                if let lists : AnyObject = dict["lists"]{
                    let photos = lists as! NSArray
                    for photo in photos {
                        array.append(ActivityPhoto(dictionary: photo as! NSDictionary, activityId:self.activityId))
                    }
                    self.photos.append(array)
//                    println("DID LOAD \(array.count) Photos")
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if array.count < self.pageCount {
                            self.waterfallView.didLoadAll()
                        } else {
                            self.waterfallView.didLoadMore()
                        }
                        self.waterfallView!.reloadData()
                    }
                }
            })
        }
    }
    
}

