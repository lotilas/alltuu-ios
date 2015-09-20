//
//  PhotoDetailViewController.swift
//  alltuu
//
//  Created by MAC on 15/9/17.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, ActivityPhotoZoomingViewDelegate{
    
    // 中心部分的scroll
    @IBOutlet weak var imageScrollView: UIScrollView!
    // 底部的属性按钮组
    @IBOutlet weak var detailPropertyButtonGroup: UIView!
    // 中间的大图
    var detailImageUImage:UIImage? {
        get {
            return detailImageView!.image
        }
        set {
            detailImageView!.image = newValue
        }
    }
    var contentGroupView:UIView?
    
    var detailImageView: UIImageView?
    
    var image:UIImage?
    
    var photographerAvatar:PhotographerBarButton?
    
    var followButton:FollowPhotographerButton?
    
    // 图片详细属性
    var photoDetail:PhotoDetail? {
        didSet {
            image = nil
            getImage()
        }
    }
    // 摄影师
    var photographer:Photographer? {
        didSet {
            refreshTopBar()
        }
    }
    
    // 前一个页面传进来的参数
    var photo:ActivityPhoto?
    
    // tap
    var tapRecognizer:UITapGestureRecognizer?
    
    let cardInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let cardTopBarHeight:CGFloat = 52
    let cardBottomBarHeight:CGFloat = 42
    let topBarInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor(colorString: "#F0F0F0")
        let oldFrame = self.imageScrollView.frame
        self.imageScrollView.frame = CGRect(x:oldFrame.origin.x, y:oldFrame.origin.y, width:self.view.frame.width, height:self.view.frame.height)
        
        // card view
        contentGroupView = UIView(frame: CGRect(x:cardInsets.left, y:cardInsets.top, width:self.imageScrollView.frame.width - cardInsets.left - cardInsets.right, height:self.imageScrollView.frame.height))
        contentGroupView!.layer.borderWidth = 1
        contentGroupView!.backgroundColor = UIColor.whiteColor()
        contentGroupView!.layer.borderColor = UIColor(colorString: AtColor.BorderLightGray.rawValue).CGColor
        
        // image view init
        detailImageView?.removeGestureRecognizer(tapRecognizer!)
        detailImageView = UIImageView(frame: CGRect(x:-cardInsets.left, y:cardTopBarHeight, width:contentGroupView!.frame.width, height:self.imageScrollView!.frame.height))
        detailImageView!.contentMode = UIViewContentMode.ScaleAspectFit
        tapRecognizer = UITapGestureRecognizer(target: self, action: "openZoomView")
        detailImageView!.addGestureRecognizer(tapRecognizer!)
        detailImageView!.userInteractionEnabled = true
        
        // follow button
        followButton = FollowPhotographerButton()
        followButton!.setPosition(contentGroupView!.frame.width - followButton!.frame.width - topBarInsets.right, y:topBarInsets.top)

        
        contentGroupView!.addSubview(followButton!)
        contentGroupView!.addSubview(detailImageView!)
        imageScrollView!.addSubview(contentGroupView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getPhotoDetail()
    }
    
    func getPhotoDetail() {
        AtHttpClient().getPhotoDetail(self.photo!.id, activityId: self.photo!.activityId, seperateId: self.photo!.seperateId, returnHandler: {(error:Int, photo:PhotoDetail?) in
            if error == 0 {
                self.photoDetail = photo
                AtHttpClient().getPhotographer(self.photoDetail!.proId, returnHandler:{(error:Int, photographer:Photographer?) in
                    self.photographer = photographer
                })
            }
        })
    }
    
    func getImage() {
        self.detailImageView!.hnk_setImageFromURL(NSURL(string: self.photoDetail!.url)!, success: { image in
            dispatch_async(dispatch_get_main_queue()){
                // 等比缩放计算
                let calculatedWidth = self.detailImageView!.frame.width
                let calculatedHeight = image.size.height * self.detailImageView!.frame.width / image.size.width
                // 设置图片 更新frame
                self.detailImageView!.frame = CGRect(x:self.detailImageView!.frame.origin.x, y:self.detailImageView!.frame.origin.y,width:self.imageScrollView.frame.width, height:calculatedHeight)
                self.detailImageUImage = image
                
                // 更新 contentView frame
                let oldFrame = self.contentGroupView!.frame
                self.contentGroupView!.frame = CGRect(x:oldFrame.origin.x, y:oldFrame.origin.y, width:oldFrame.width, height:self.detailImageView!.frame.height + self.cardTopBarHeight + self.cardBottomBarHeight)
                
                // scrollView
                self.imageScrollView.contentSize = CGSize(width: self.contentGroupView!.frame.width, height: self.contentGroupView!.frame.height)
            }
        })
    }
    
    func refreshTopBar(){
        dispatch_async(dispatch_get_main_queue()){
            self.photographerAvatar = PhotographerBarButton(photographer: self.photographer!)
            let oldFrame = self.photographerAvatar!.frame
            self.photographerAvatar!.frame = CGRect(x:oldFrame.origin.x + self.topBarInsets.left, y:oldFrame.origin.y + self.topBarInsets.top, width:oldFrame.width, height:oldFrame.height)
            self.contentGroupView!.addSubview(self.photographerAvatar!)
        }
    }
    
    func lsImgZoomView(close:Bool){
        
    }

    
    func openZoomView(){
        
        var imgsize = self.detailImageUImage!.size
        var frameHeight = imgsize.height * self.view.frame.width / imgsize.width
        var frameY = (self.view.frame.height - imgsize.height) / 2
        var baseframe = CGRect(x:0,y: frameY, width:self.view.frame.width, height:frameHeight)
        
        var zoomv = ActivityPhotoZoomingView(baseframe: baseframe, p:self.photoDetail!)
        zoomv.delegate = self
        zoomv.setCurrImg(self.detailImageView!.image!)
        zoomv.show()
        
        zoomv.blockClose = {(done:Bool) -> Void in
            //
            self.detailImageView!.hidden = false
        }

    }
}
