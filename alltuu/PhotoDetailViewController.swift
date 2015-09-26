//
//  PhotoDetailViewController.swift
//  alltuu
//
//  Created by MAC on 15/9/17.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class PhotoDetailViewController: AtViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, AtScrollViewDelegate, AtNavigationDelegate{
    
    // 中心部分的scroll
    @IBOutlet weak var imageScrollView: UIScrollView!
    // 底部的属性按钮组
    @IBOutlet weak var detailPropertyButtonGroup: DetailPropertyButtonGroup!
    
    var contentGroupViewLeft:PhotoDetailCard?
    var contentGroupViewMiddle:PhotoDetailCard?
    var contentGroupViewRight:PhotoDetailCard?
    var contentGroupViewTemp:PhotoDetailCard?
    
    var likeBtn:PropertyLikeCountButton?
    var cmtBtn:PropertyCommentButton?
    var shareBtn:PropertyShareButton?
    var downloadBtn:PropertyDownloadButton?

    // 前一个页面传进来的参数
    var photoId:Int?
    var activityId:Int?
    var seperateId:Int?
    var seperateName:String?
    var activityName:String?
    var placeHolderImageLeft:UIImage?
    var placeHolderImageMiddle:UIImage?
    var placeHolderImageRight:UIImage?
    
    
    // swipe
    var swipeRightRecognizer:UISwipeGestureRecognizer?
    var swipeLeftRecognizer:UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        // 禁用右滑手势
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
        self.navigationController!.interactivePopGestureRecognizer.enabled = false
        self.navigationController!.interactivePopGestureRecognizer.delaysTouchesBegan = false
        self.navigationController!.interactivePopGestureRecognizer.delaysTouchesEnded = false
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return false
        } else {
            return true
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor(colorString: "#F0F0F0")
        // scrollview frame
        var oldFrame = imageScrollView.frame
        imageScrollView.frame = CGRect(x:oldFrame.origin.x, y:oldFrame.origin.y, width:self.view.frame.width, height:self.view.frame.height)
        oldFrame = detailPropertyButtonGroup.frame
        detailPropertyButtonGroup.frame = CGRect(x:oldFrame.origin.x, y:oldFrame.origin.y, width:self.view.frame.width, height:oldFrame.height)
        
        // gesture
        swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: "onPreviousPageSwipe:")
        swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: "onNextPageSwipe:")
        swipeLeftRecognizer!.direction = UISwipeGestureRecognizerDirection.Left
        imageScrollView.addGestureRecognizer(swipeLeftRecognizer!)
        imageScrollView.addGestureRecognizer(swipeRightRecognizer!)
        
        contentGroupViewLeft = PhotoDetailCard(origin:CGPoint(x:-375,y:0),size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), activityName:self.activityName,placeHolderImage:nil,navigationControllerDelegate:self)
        
        contentGroupViewMiddle = PhotoDetailCard(origin:CGPoint(x:0,y:0),size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), activityName:self.activityName,placeHolderImage:placeHolderImageMiddle,navigationControllerDelegate:self)
        
        if placeHolderImageMiddle != nil {
            let calculatedWidth = self.contentGroupViewMiddle!.frame.width
            // 等比缩放计算
            let calculatedHeight = self.placeHolderImageMiddle!.size.height * self.contentGroupViewMiddle!.frame.width / self.placeHolderImageMiddle!.size.width
            
            self.onContentSizeChange(CGSize(width: calculatedWidth, height:calculatedHeight + self.contentGroupViewMiddle!.cardTopBarHeight + contentGroupViewMiddle!.cardBottomBarHeight + contentGroupViewMiddle!.cardInsets.top + contentGroupViewMiddle!.cardInsets.bottom))
        }
        
        contentGroupViewRight = PhotoDetailCard(origin:CGPoint(x:375,y:0), size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), activityName:self.activityName,placeHolderImage:nil,navigationControllerDelegate:self)

        imageScrollView!.addSubview(contentGroupViewLeft!)
        imageScrollView!.addSubview(contentGroupViewMiddle!)
        imageScrollView!.addSubview(contentGroupViewRight!)

        detailPropertyButtonGroup.layer.borderWidth = 1
        detailPropertyButtonGroup.layer.borderColor = UIColor(colorString: AtColor.BorderLightGray.rawValue).CGColor
        likeBtn = PropertyLikeCountButton(labelText: "0")
        detailPropertyButtonGroup.appendPropertyButton(likeBtn!)
        cmtBtn = PropertyCommentButton(labelText: "0")
        detailPropertyButtonGroup.appendPropertyButton(cmtBtn!)
        shareBtn = PropertyShareButton()
        detailPropertyButtonGroup.appendPropertyButton(shareBtn!)
        downloadBtn = PropertyDownloadButton()
        detailPropertyButtonGroup.appendPropertyButton(downloadBtn!)
        detailPropertyButtonGroup.layoutAllButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        if seperateName != nil {
            self.navigationView!.setTitle(seperateName!)
        } else {
            self.navigationView!.setTitle("照片详情")
        }
        
        getPhotoDetail()
    }
    
    func getPhotoDetail() {
        AtHttpClient().getCurrentPhotoDetail(self.photoId!, activityId: self.activityId!, seperateId: self.seperateId!, returnHandler: {(error:Int, photo:PhotoDetail?) in
            if error == 0 {
                self.contentGroupViewMiddle!.photoDetail = photo
                self.updateProperties()
                AtHttpClient().getPhotographer(photo!.proId, returnHandler:{(error:Int, photographer:Photographer?) in
                    self.contentGroupViewMiddle!.photographer = photographer
                })
                self.getPreviousAndNextPhotoDetails(photo);
            }
        })
    }
    
    func getPreviousAndNextPhotoDetails(photoDetail:PhotoDetail?){
        if let pd = photoDetail {
            AtHttpClient().getPreviousPhotoDetail(self.photoId!, activityId: self.activityId!, seperateId: self.seperateId!, returnHandler: {(error:Int, photo:PhotoDetail?) in
                if error == 0 {
                    if photo != nil {
                        self.contentGroupViewLeft!.photoDetail = photo
                        AtHttpClient().getPhotographer(photo!.proId, returnHandler:{(error:Int, photographer:Photographer?) in
                            self.contentGroupViewLeft!.photographer = photographer
                        })
                    }
                }
            })
            AtHttpClient().getNextPhotoDetail(self.photoId!, activityId: self.activityId!, seperateId: self.seperateId!, returnHandler: {(error:Int, photo:PhotoDetail?) in
                if error == 0 {
                    if photo != nil {
                        self.contentGroupViewRight!.photoDetail = photo
                        AtHttpClient().getPhotographer(photo!.proId, returnHandler:{(error:Int, photographer:Photographer?) in
                            self.contentGroupViewRight!.photographer = photographer
                        })
                    }
                }
            })
        }
    }
    
    func onPreviousPageSwipe(sender:UISwipeGestureRecognizer) {
        if  self.contentGroupViewLeft!.photoDetail != nil {
            self.swipe(self.view.frame.width, scrollerViewContentHeight:self.contentGroupViewLeft!.frame.height)
            if self.contentGroupViewTemp != nil {
                self.contentGroupViewTemp!.removeFromSuperview()
            }
            self.contentGroupViewTemp = self.contentGroupViewRight
            self.contentGroupViewRight = self.contentGroupViewMiddle
            self.contentGroupViewMiddle = self.contentGroupViewLeft
            self.contentGroupViewLeft = PhotoDetailCard(origin:CGPoint(x:-UIScreen.mainScreen().bounds.width,y:0), size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), activityName:self.activityName,placeHolderImage:nil, navigationControllerDelegate:self)
            self.imageScrollView.addSubview(self.contentGroupViewLeft!)
            self.photoId = self.contentGroupViewMiddle!.photoDetail!.id
            AtHttpClient().getPreviousPhotoDetail(self.photoId!, activityId: self.activityId!, seperateId: self.seperateId!, returnHandler: {(error:Int, photo:PhotoDetail?) in
                if error == 0 {
                    if photo != nil {
                        self.contentGroupViewLeft!.photoDetail = photo
                        AtHttpClient().getPhotographer(photo!.proId, returnHandler:{(error:Int, photographer:Photographer?) in
                            self.contentGroupViewLeft!.photographer = photographer
                        })
                    }
                }
            })
        }
    }
    
    func onNextPageSwipe(sender:UISwipeGestureRecognizer) {
        if  self.contentGroupViewRight!.photoDetail != nil {
            self.swipe(-self.view.frame.width, scrollerViewContentHeight:self.contentGroupViewRight!.frame.height)
            if self.contentGroupViewTemp != nil {
                self.contentGroupViewTemp!.removeFromSuperview()
            }
            self.contentGroupViewTemp = self.contentGroupViewLeft
            self.contentGroupViewLeft = self.contentGroupViewMiddle
            self.contentGroupViewMiddle = self.contentGroupViewRight
            self.contentGroupViewRight = PhotoDetailCard(origin:CGPoint(x:UIScreen.mainScreen().bounds.width,y:0), size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), activityName:self.activityName,placeHolderImage:nil, navigationControllerDelegate:self)
            self.imageScrollView.addSubview(self.contentGroupViewRight!)
            self.photoId = self.contentGroupViewMiddle!.photoDetail!.id
            AtHttpClient().getNextPhotoDetail(self.photoId!, activityId: self.activityId!, seperateId: self.seperateId!, returnHandler: {(error:Int, photo:PhotoDetail?) in
                if error == 0 {
                    if photo != nil {
                        self.contentGroupViewRight!.photoDetail = photo
                        AtHttpClient().getPhotographer(photo!.proId, returnHandler:{(error:Int, photographer:Photographer?) in
                            self.contentGroupViewRight!.photographer = photographer
                        })
                    }
                }
            })
        }
    }
    
    private func swipe(xDistance:CGFloat, scrollerViewContentHeight:CGFloat){
        self.onContentSizeChange(CGSize(width: UIScreen.mainScreen().bounds.width, height: scrollerViewContentHeight))
        UIView.animateWithDuration(0.5, animations: {
            var oldCenter = self.contentGroupViewMiddle!.center
            self.contentGroupViewMiddle!.center = CGPoint(x:oldCenter.x+xDistance,y:oldCenter.y)
            var oldCenter2 = self.contentGroupViewLeft!.center
            self.contentGroupViewLeft!.center = CGPoint(x:oldCenter2.x+xDistance,y:oldCenter2.y)
            var oldCenter3 = self.contentGroupViewRight!.center
            self.contentGroupViewRight!.center = CGPoint(x:oldCenter3.x+xDistance,y:oldCenter3.y)

        })
    }
    
    func updateProperties(){
        dispatch_async(dispatch_get_main_queue()) {
            if let photo = self.contentGroupViewMiddle!.photoDetail {
                self.likeBtn!.updateLabelText("\(photo.likeTimes)")
                self.cmtBtn!.updateLabelText("\(photo.cmtTimes)")
            }
        }
    }
    
    func onContentSizeChange(newSize: CGSize) {
        println("SIZE CHANGE TO : \(newSize)")
        self.imageScrollView.contentSize = newSize
    }
    
    func shouldPopToParentView() {
        self.navigationController!.popViewControllerAnimated(true)
    }
}
