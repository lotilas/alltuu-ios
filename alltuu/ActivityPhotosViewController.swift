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

class ActivityPhotosViewController: AtViewController, UICollectionViewDelegate,UICollectionViewDataSource,ActivityPhotoZoomingViewDelegate{
    
    @IBOutlet weak var waterfallView: ActivityPhotosView!
    
    
    @IBOutlet weak var photographerBarView: PhotographerBarView!
    
    
    @IBOutlet weak var seperateBarView: SeperateBarView!
    
    var pageCount = 12
    var currentPage = 0
    var activityId = 0
    var activityTitle :String?
    var seperateId = 0
    
    var seperates = [Seperate]()
    var photos = [[ActivityPhoto]]()
    var photographers = [Photographer]()
    
    var titles:Array<String>?
    
    //相对位置
    var content_y =  CGFloat()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if activityTitle != nil {
            self.navigationView!.setTitle(activityTitle!)
        }
    }
    
    func resetData(){
        photos.removeAll()
        seperates.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resetData()
        
        //waterfallView
        waterfallView.delegate = self
        waterfallView.dataSource = self
        
        self.seperateBarView.seperateSwitchDelegate = self      //seperate switch
        
        self.waterfallView.initLoadMoreFootView( { () -> () in
            self.delay(0.5, closure: { () -> () in})
            self.delay(0.5, closure: { () -> () in
                self.getPhotos()
            })
        }, noMoreText: "没有更多照片啦~")
        
        self.getSeperates()
    }
    
    //UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        println("count1:\(photos.count)")
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        println("count:\(photos[section].count)")
        return photos[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AtIdentifies.ActivityPhotoCell.rawValue, forIndexPath: indexPath) as! ActivityPhotoCell
        
        cell.photo = self.photos[indexPath.section][indexPath.item]
        
        return cell
    }
    
    
    
    //UICollectionViewDele override gate
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        //
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ActivityPhotoCell
//        cell.photoView.hidden = true
//        
        //小图在当前屏幕的位置
//        var baseframe = CGRectMake(cell.frame.origin.x, cell.frame.origin.y-content_y+self.waterfallView.frame.origin.y, cell.frame.size.width, cell.frame.size.height)
//        println("baseframe:\(baseframe.origin.x)  \(baseframe.origin.y)  \(baseframe.size.width)  \(baseframe.size.height)")
//        var zoomv = ActivityPhotoZoomingView(baseframe: baseframe, p:cell.photo!)
//        zoomv.delegate = self
//        zoomv.setCurrImg(cell.photoView.image!)       //这个是小图 在里面加载大图
//        zoomv.show()
//        zoomv.blockClose = {(done:Bool) -> Void in
//            cell.photoView.hidden = false
//        }
//    }
    
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
        Shared.imageCache.removeAll()
    }
    
    // MARK: http获取
    //划分
    func getSeperates(){
        if activityId > 0 {
            AtHttpClient().getSeperates(activityId, returnHandler:{ (error:Int, seperates:Array<Seperate>) in
                self.seperates = seperates
                if self.seperates.count > 0{
                    self.seperateId = seperates[0].sepId
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.loadSepSelector()
                    }
                    self.getPhotos()
                    self.getPhotographers()
                }
            })
        }
    }
    
    //摄影师
    func getPhotographers(){
        photographerBarView.removeAllPhotographers()
        if seperateId > 0 {
            AtHttpClient().getPhotographers(seperateId, returnHandler: { (error:Int, photographers:Array<Photographer>) in
                self.photographers = photographers
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if photographers.count > 0 {
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            self.loadPhotographers()
                        }
                    }
                }
            })
        }
    }

    //照片
    func getPhotos(){
        if activityId > 0 {
            currentPage++
            AtHttpClient().getPhotos(activityId, seperateId:seperateId, pageCount:pageCount, currentPage:currentPage, returnHandler:{ (error:Int, seperates:Array<ActivityPhoto>) in
                self.photos.append(seperates)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.waterfallView.showFootView()
                    if seperates.count < self.pageCount {
                        self.waterfallView.didLoadAll()
                    } else {
                        self.waterfallView.didLoadMore()
                    }
                    self.waterfallView!.reloadData()
                }

            })
        }
    }
    
    func loadSepSelector(){
        for seperate in seperates {
            var btn:SeperateBarButton = SeperateBarButton(titleText: seperate.sepName, sepId:seperate.sepId)
            seperateBarView.addSubview(btn)
        }
        self.seperateBarView.highlightButtonAt(0)
    }
    
    func loadPhotographers(){
        for photographer in photographers {
            var btn:PhotographerBarButton = PhotographerBarButton(photographer: photographer)
            photographerBarView.addSubview(btn)
        }
    }
    
    // MARK: seperateSwitchDelegate
    //点击按钮切换划分
    func onSeperateSwitch(sender:UIButton){
        if let button = sender as? SeperateBarButton {
            seperateId = button.sepId
            seperateBarView.highlightButton(button)
            currentPage = 0
            photographers.removeAll()
            photos.removeAll()
            waterfallView.reloadData()
            waterfallView.scrollRectToVisible(CGRect(x: 0,y: 0,width: waterfallView.frame.width,height: 0), animated: false)
            getPhotos()
            getPhotographers()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? ActivityPhotoCell {
            if let destController = segue.destinationViewController as? PhotoDetailViewController {
                destController.photo = cell.photo
            }
        }
    }
}

