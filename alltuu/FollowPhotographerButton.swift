//
//  FollowPhotographerButton.swift
//  alltuu
//
//  Created by MAC on 15/9/18.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

public enum FollowStatus {
    case YES
    case NO
}

class FollowPhotographerButton: UIButton {
    
    let width:CGFloat = 46
    let height:CGFloat = 30
    
    var followStatus:FollowStatus? {
        didSet {
            if followStatus != nil {
                self.setFollowStatus(followStatus!)
            }
        }
    }
    
    convenience init() {
        self.init(x:0, y:0)
    }
    
    init(x:CGFloat, y:CGFloat) {
        super.init(frame: CGRect(x:x, y:y, width:width, height:height))
        self.layer.cornerRadius = 15
        self.setTitle("关注", forState: UIControlState.Normal)
        self.layer.borderWidth = 1
        self.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.followStatus = FollowStatus.NO
        self.addTarget(self, action: "onFollowButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setFollowStatus(status:FollowStatus) {
        if status == FollowStatus.YES {
            self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.layer.backgroundColor = UIColor(colorString: AtColor.BlueNormal.rawValue).CGColor
            self.layer.borderColor = UIColor(colorString: AtColor.BlueNormal.rawValue).CGColor
        } else {
            self.setTitleColor(UIColor(colorString: AtColor.BorderDarkGray.rawValue), forState: UIControlState.Normal)
            self.layer.backgroundColor = UIColor.whiteColor().CGColor
            self.layer.borderColor = UIColor(colorString: AtColor.BorderDarkGray.rawValue).CGColor

        }
    }
    
    func onFollowButtonClick(){
        dispatch_async(dispatch_get_main_queue()) {
            if self.followStatus == FollowStatus.NO {
                self.followStatus = FollowStatus.YES
            } else {
                self.followStatus = FollowStatus.NO
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPosition(x:CGFloat, y:CGFloat){
        let oldFrame = self.frame
        self.frame = CGRect(x:x, y:y, width:oldFrame.width, height:oldFrame.height)
    }
}
