//
//  PhotoDetailViewController.swift
//  alltuu
//
//  Created by MAC on 15/9/17.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, AtScrollViewDelegate{
    
    // 中心部分的scroll
    @IBOutlet weak var imageScrollView: UIScrollView!
    // 底部的属性按钮组
    @IBOutlet weak var detailPropertyButtonGroup: UIView!
    
    var contentGroupViewLeft:PhotoDetailCard?
    var contentGroupViewMiddle:PhotoDetailCard?
    var contentGroupViewRight:PhotoDetailCard?
    var contentGroupViewTemp:PhotoDetailCard?

    // 前一个页面传进来的参数
    var photoId:Int?
    var activityId:Int?
    var seperateId:Int?
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
        
        setupUI()
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
        
        // gesture
        swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: "onPreviousPageSwipe:")
        swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: "onNextPageSwipe:")
        swipeLeftRecognizer!.direction = UISwipeGestureRecognizerDirection.Left
        imageScrollView.addGestureRecognizer(swipeLeftRecognizer!)
        imageScrollView.addGestureRecognizer(swipeRightRecognizer!)
        
        contentGroupViewLeft = PhotoDetailCard(origin:CGPoint(x:-375,y:0),size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), placeHolderImage:nil)
        
        contentGroupViewMiddle = PhotoDetailCard(origin:CGPoint(x:0,y:0),size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), placeHolderImage:placeHolderImageMiddle)
        
        if placeHolderImageMiddle != nil {
            let calculatedWidth = self.contentGroupViewMiddle!.frame.width
            // 等比缩放计算
            let calculatedHeight = self.placeHolderImageMiddle!.size.height * self.contentGroupViewMiddle!.frame.width / self.placeHolderImageMiddle!.size.width
            self.onContentSizeChange(CGSize(width: calculatedWidth, height:calculatedHeight))
        }
        
        contentGroupViewRight = PhotoDetailCard(origin:CGPoint(x:375,y:0), size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), placeHolderImage:nil)

        imageScrollView!.addSubview(contentGroupViewLeft!)
        imageScrollView!.addSubview(contentGroupViewMiddle!)
        imageScrollView!.addSubview(contentGroupViewRight!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getPhotoDetail()
    }
    
    func getPhotoDetail() {
        AtHttpClient().getCurrentPhotoDetail(self.photoId!, activityId: self.activityId!, seperateId: self.seperateId!, returnHandler: {(error:Int, photo:PhotoDetail?) in
            if error == 0 {
                self.contentGroupViewMiddle!.photoDetail = photo
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
            self.contentGroupViewLeft = PhotoDetailCard(origin:CGPoint(x:-UIScreen.mainScreen().bounds.width,y:0), size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), placeHolderImage:nil)
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
            self.contentGroupViewRight = PhotoDetailCard(origin:CGPoint(x:UIScreen.mainScreen().bounds.width,y:0), size:CGSize(width:imageScrollView.frame.width, height:imageScrollView.frame.height), placeHolderImage:nil)
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
    
    func onContentSizeChange(newSize: CGSize) {
        println("SIZE CHANGE TO : \(newSize)")
        self.imageScrollView.contentSize = newSize
    }
}
