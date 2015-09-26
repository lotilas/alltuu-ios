//
//  PhotoDetailCard.swift
//  alltuu
//
//  Created by MAC on 15/9/20.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class PhotoDetailCard: UIView {
    
    let cardInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let cardTopBarHeight:CGFloat = 52
    let cardBottomBarHeight:CGFloat = 42
    let topBarInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let bottomBarInsets = UIEdgeInsets(top:12, left:10, bottom:10, right:10)
    let activityButtonMarginTop:CGFloat = 4
    
    let ComeFrom = "来自："
    var activity:String = "喔图"
    
    // 中间的大图
    var detailImageUImage:UIImage? {
        get {
            return detailImageView?.image
        }
        set {
            if detailImageView != nil {
                detailImageView!.image = newValue
            }
        }
    }
    
    var detailImageView: UIImageView?

    var placeHolderImage:UIImage?
    
    var photographerAvatar:PhotographerBarButton?
    var followButton:FollowPhotographerButton?
    var activityButton:UIButton?
    var comeFromLabel:UILabel?
    
    // 摄影师
    var photographer:Photographer? {
        didSet {
            self.refreshTopBar(photographer!)
        }
    }
    
    // tap
    var tapRecognizer:UITapGestureRecognizer?
    
    var navigationDelegate:AtNavigationDelegate?
    
    var photoDetail:PhotoDetail? {
        didSet {
            if photoDetail != nil {
                self.refreshImage(photoDetail!.url)
            }
        }
    }
    
    init(origin:CGPoint, size:CGSize, activityName:String?, placeHolderImage:UIImage?, navigationControllerDelegate:AtNavigationDelegate? = nil){
        var rect = CGRect(x:origin.x + cardInsets.left, y:origin.y + cardInsets.top, width:size.width - cardInsets.left - cardInsets.right, height:size.height)
        super.init(frame: rect)
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor(colorString: AtColor.BorderLightGray.rawValue).CGColor

        if activityName != nil {
            self.activity = activityName!
        }
        
        if let ph = placeHolderImage {
            dispatch_async(dispatch_get_main_queue()) {
                self.detailImageUImage = ph
                self.resizeFrame(ph)
            }
        }
        
        self.navigationDelegate = navigationControllerDelegate
        
        // 图片 摄影师 关注
        addSubviews()
        
    }
    
    func addSubviews() {
        // image view init
        detailImageView = UIImageView(frame: CGRect(x:0, y:cardTopBarHeight, width:self.frame.width, height:self.frame.height))
        //println(detailImageView!.frame)
        if tapRecognizer != nil {
            detailImageView!.removeGestureRecognizer(tapRecognizer!)
        }
        detailImageView!.contentMode = UIViewContentMode.ScaleAspectFit
        tapRecognizer = UITapGestureRecognizer(target: self, action: "openZoomView")
        detailImageView!.addGestureRecognizer(tapRecognizer!)
        detailImageView!.userInteractionEnabled = true
        
        // follow button
        followButton = FollowPhotographerButton()
        followButton!.setPosition(self.frame.width - followButton!.frame.width - topBarInsets.right, y:topBarInsets.top)
        
        comeFromLabel = UILabel(frame: CGRect(x:bottomBarInsets.left,y:self.frame.height-30,width:100,height:100))
        comeFromLabel!.font = UIFont.systemFontOfSize(14)
        comeFromLabel!.text = "\(ComeFrom)"
        comeFromLabel!.sizeToFit()
        
        activityButton = UIButton(frame: CGRect(x:bottomBarInsets.left + comeFromLabel!.frame.width,y:self.frame.height-30,width:100,height:100))
        activityButton!.titleLabel!.font = UIFont.systemFontOfSize(16)
        activityButton!.setTitle("\(activity)", forState: UIControlState.Normal)
        activityButton!.setTitleColor(UIColor(colorString: AtColor.BlueActive.rawValue), forState: UIControlState.Normal)
        activityButton!.sizeToFit()
        activityButton!.addTarget(self, action: "onActivityButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(followButton!)
        self.addSubview(detailImageView!)
        self.addSubview(comeFromLabel!)
        self.addSubview(activityButton!)
    }
    
    func onActivityButtonClick(){
        if let navi = navigationDelegate {
            navigationDelegate!.shouldPopToParentView()
        }
    }
    
    
    func refreshTopBar(photographer:Photographer){
        dispatch_async(dispatch_get_main_queue()){
            self.photographerAvatar = PhotographerBarButton(photographer: photographer)
            let oldFrame = self.photographerAvatar!.frame
            self.photographerAvatar!.frame = CGRect(x:oldFrame.origin.x + self.topBarInsets.left, y:oldFrame.origin.y + self.topBarInsets.top, width:oldFrame.width, height:oldFrame.height)
            self.addSubview(self.photographerAvatar!)
            if self.photographer!.isFollowed == 0{
                self.followButton!.setFollowStatus(FollowStatus.NO)
            } else {
                self.followButton!.setFollowStatus(FollowStatus.YES)
            }
        }
    }
    
    func refreshImage(url:String){
        self.detailImageView!.replaceImageThroughCacheAndDoSomething(url, cacheKey:  self.photoDetail!.toCacheKey(PhotoSize.SMALL), cacheExpire: AtCacheManager.A_WEEK, something:self.resizeFrame)
    }
    
    private func resizeFrame(image:UIImage?){
        if image != nil {
            // 等比缩放计算
            let calculatedWidth = self.detailImageView!.frame.width
            let calculatedHeight = image!.size.height * calculatedWidth / image!.size.width
            //println(calculatedHeight)
            // 更新frame
            self.detailImageView!.frame = CGRect(x:self.detailImageView!.frame.origin.x, y:self.detailImageView!.frame.origin.y,width:self.frame.width, height:calculatedHeight)
            
            // 更新 contentView frame
            let oldFrame = self.frame
            self.frame = CGRect(x:oldFrame.origin.x, y:oldFrame.origin.y, width:oldFrame.width, height:self.detailImageView!.frame.height + self.cardTopBarHeight + self.cardBottomBarHeight)
            
            var of = self.comeFromLabel!.frame
            self.comeFromLabel!.frame = CGRect(x:of.origin.x, y:self.cardTopBarHeight + self.detailImageView!.frame.height + self.bottomBarInsets.top, width:of.width, height:of.height)
            
            of = self.activityButton!.frame
            self.activityButton!.frame = CGRect(x:of.origin.x, y:self.cardTopBarHeight + self.detailImageView!.frame.height + activityButtonMarginTop, width:of.width, height:of.height)
            
        }
    }
    
    // 打开放大图
    func openZoomView(){
        if let img = self.detailImageUImage {
            let imgsize = img.size
            let fullScreenFrame = UIScreen.mainScreen().bounds
//            println("\(fullScreenFrame)")
            let frameHeight = imgsize.height * fullScreenFrame.width / imgsize.width
            let frameY = (fullScreenFrame.height - frameHeight) / 2
//            let frameY:CGFloat = 0
            var baseframe = CGRect(x:0,y: frameY, width:fullScreenFrame.width, height:frameHeight)
            var zoomv = ActivityPhotoZoomingView(baseframe: baseframe, p:self.photoDetail!,image:self.detailImageUImage!)
            zoomv.setCurrImg(self.detailImageUImage!)
            zoomv.show()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
