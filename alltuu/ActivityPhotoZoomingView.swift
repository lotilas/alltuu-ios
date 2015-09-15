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
    
    //close代理
    var delegate: ActivityPhotoZoomingViewDelegate?
    
    //当前图片
    var currimg = UIImage()
    
    //
    var rootview: UIScrollView?
    var zoomview: UIImageView?
    
    //放大缩小mark
    var count = NSInteger()
    
    //初始大小位置
    var base_frame = CGRect()
    
    var photo:ActivityPhoto?
    
    //block返回
    var blockClose:closeBlock?
    
    init(baseframe: CGRect, p:ActivityPhoto) {
        //
        super.init(frame: baseframe)
        
        self.photo = p
        
        base_frame = baseframe
        
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.backgroundColor = UIColor.clearColor()
        
        //
        rootview = UIScrollView(frame: self.bounds)
        rootview!.backgroundColor = UIColor(red: 0.031, green: 0.031, blue: 0.031, alpha: 0)
        rootview!.delegate = self
        rootview!.showsHorizontalScrollIndicator = false
        rootview!.showsVerticalScrollIndicator = false
        rootview!.maximumZoomScale = 2.0
        rootview!.minimumZoomScale = 1.0
        self.addSubview(rootview!)
        
        //
        zoomview = UIImageView(frame: base_frame)
        zoomview!.userInteractionEnabled = true
        zoomview!.contentMode = UIViewContentMode.ScaleAspectFill
        zoomview!.clipsToBounds = true
        zoomview!.backgroundColor = UIColor.lightGrayColor()
        rootview!.addSubview(zoomview!)
        
        var request = HTTPTask()
        request.GET("http://m.alltuu.com/photo/\(self.photo!.activityId)/\(self.photo!.seperateId)/\(self.photo!.id)/0", parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return
            }
            let data = response.responseObject as! NSData
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            var array = [Seperate]()
            if let lists : NSArray = dict["lists"] as? NSArray{
                if let info : NSDictionary = lists[0] as? NSDictionary{
                    self.zoomview?.hnk_setImageFromURL(NSURL(string:info["url"] as! String)!,success:{i in
                        self.zoomview?.image = i
                    },failure:{j in
                        println("F : \(j?.description)")
                    })
                }
            }
        })
        
        
        
       

        
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
    
    //传递一张图片
    func setCurrImg(img:UIImage){
        //
        currimg = img
        self.zoomview!.image = currimg
        
        animationOfFrame()
        
    }
    
    //渐变动画
    func animationOfFrame(){
        
        let imgsize = currimg.size
        
        var newRect = CGRect()
        if (self.bounds.size.width * imgsize.height / imgsize.width > self.bounds.size.height){
            //
            newRect = CGRectMake(
                0,
                0,
                self.bounds.size.width,
                self.bounds.size.width*imgsize.height/imgsize.width);
            self.rootview!.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.width*imgsize.height/imgsize.width);
            
        }else{
            //
            newRect = CGRectMake(
                0,
                (self.bounds.size.height-self.bounds.size.width*imgsize.height/imgsize.width)/2,
                self.bounds.size.width,
                self.bounds.size.width*imgsize.height/imgsize.width);
        }
        
        //
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            //
            self.zoomview!.frame = newRect
            self.rootview!.backgroundColor = UIColor(red: 0.031, green: 0.031, blue: 0.031, alpha: 0.75)
            
            }) { (done:Bool) -> Void in
                //
                
        }
        
    }
    
    //展示
    func show(){
        //
        var app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.window!.addSubview(self)
        
    }
    
    //关闭
    func actionOfCloseTap(sender:UITapGestureRecognizer!){
        self.backgroundColor = UIColor.clearColor()
        self.rootview!.setZoomScale(1.0, animated: true)
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            //
            
            self.zoomview!.frame = self.base_frame
            self.rootview!.backgroundColor = UIColor(red: 0.031, green: 0.031, blue: 0.031, alpha: 0)
            
            
            }) { (done: Bool) -> Void in
                //
                if (done){
                    self.removeFromSuperview()
                }
                
                //关闭的代理
                self.delegate!.lsImgZoomView(true)
                //
                self.blockClose!(true)
        }
        
    }
    
    //双击
    func actionOfDoubleTap(sender:UITapGestureRecognizer!){
        
        //
        if (sender.state == UIGestureRecognizerState.Ended){
            if (count == 0){
                //
                self.rootview!.setZoomScale(2.0, animated: true)
                count = 1
                
            }else{
                //
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
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
