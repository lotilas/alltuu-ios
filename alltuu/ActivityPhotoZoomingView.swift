//
//  LSImgZoomView.swift
//  LSFlowView
//
//  Created by  tsou117 on 15/7/6.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

import UIKit
import SwiftHTTP

typealias closeBlock = (Bool) -> Void

protocol ActivityPhotoZoomingViewDelegate{
    
    func lsImgZoomView(close:Bool)
    
}

class ActivityPhotoZoomingView: UIView,UIScrollViewDelegate {
    
    //当前图片
    var currimg:UIImage?
    
    //
    var rootview: UIScrollView?
    var zoomview: UIImageView?
    
    //放大缩小mark
    var count = NSInteger()
    
    //初始大小位置
    var base_frame = CGRect()
    
    var photo:PhotoDetail?
    
    init(baseframe: CGRect, p:PhotoDetail, image:UIImage) {
        //
        super.init(frame: baseframe)
        
        self.photo = p
        
        base_frame = baseframe
        
        self.currimg = image
        
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.backgroundColor = UIColor.blackColor()
        
        //
        rootview = UIScrollView(frame: self.bounds)
        rootview!.backgroundColor = UIColor.clearColor()
        rootview!.delegate = self
        rootview!.showsHorizontalScrollIndicator = false
        rootview!.showsVerticalScrollIndicator = false
        rootview!.maximumZoomScale = 2.0
        rootview!.minimumZoomScale = 1.0
        rootview!.alpha = 0
        self.addSubview(rootview!)
        
        //
        zoomview = UIImageView(frame: base_frame)
        zoomview!.userInteractionEnabled = true
        zoomview!.contentMode = UIViewContentMode.ScaleAspectFill
        zoomview!.clipsToBounds = true
        zoomview!.backgroundColor = UIColor.blackColor()
        rootview!.addSubview(zoomview!)
     
        zoomview!.loadImageThroughCache(self.photo!.smallUrl, placeHolder:self.currimg!,cacheKey: p.toCacheKey(PhotoSize.MIDDLE), cacheExpire: AtCacheManager.A_WEEK)
        
        //双击事件
        let doubleTap = UITapGestureRecognizer(target: self, action: "actionOfDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        zoomview!.addGestureRecognizer(doubleTap)
        
        //关闭
        let closeTap = UITapGestureRecognizer(target: self, action: "actionOfCloseTap:")
        closeTap.numberOfTapsRequired = 1
        closeTap.numberOfTouchesRequired = 1
        closeTap.requireGestureRecognizerToFail(doubleTap)
        rootview!.addGestureRecognizer(closeTap)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //传递一张图片
    func setCurrImg(img:UIImage){
        //
        currimg = img
        self.zoomview!.image = currimg
        
        animationOfFrame()
        
    }
    
    //渐变动画
    func animationOfFrame(){
        self.rootview!.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.rootview!.alpha = 1
        }) { (done:Bool) -> Void in
                //
                
        }
        
    }
    
    //展示
    func show(){
        var app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.window!.addSubview(self)
        
    }
    
    //关闭
    func actionOfCloseTap(sender:UITapGestureRecognizer!){
        self.backgroundColor = UIColor.clearColor()
        self.rootview!.setZoomScale(1.0, animated: true)
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            //
            
//            self.zoomview!.frame = self.base_frame
//            self.rootview!.backgroundColor = UIColor.clearColor()
            self.rootview!.alpha = 0
            
        }) { (done: Bool) -> Void in
                //
                if (done){
                    self.removeFromSuperview()
                }
        }
        
    }
    
    //双击
    func actionOfDoubleTap(sender:UITapGestureRecognizer!){
        if (sender.state == UIGestureRecognizerState.Ended){
            if (count == 0){
                self.rootview!.setZoomScale(2.0, animated: true)
                count = 1
            }else{
                self.rootview!.setZoomScale(1.0, animated: true)
                count = 0
            }
        }
    }
    
    //UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        //
        if (zoomview != nil){
            return zoomview!
        }
        return nil
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        //
        if (zoomview != nil){
            var offsetx = self.rootview!.bounds.size.width > self.rootview!.contentSize.width ? (self.rootview!.bounds.size.width - self.rootview!.contentSize.width)*0.5 : 0.0
            
            var offsety = self.rootview!.bounds.size.height > self.rootview!.contentSize.height ? (self.rootview!.bounds.size.height - self.rootview!.contentSize.height)*0.5 : 0.0;
            
            self.zoomview!.center = CGPointMake(self.rootview!.contentSize.width*0.5+offsetx, self.rootview!.contentSize.height*0.5+offsety)
        }
    }
}
