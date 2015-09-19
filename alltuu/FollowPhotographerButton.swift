//
//  FollowPhotographerButton.swift
//  alltuu
//
//  Created by MAC on 15/9/18.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class FollowPhotographerButton: UIButton {
    
    let width:CGFloat = 46
    let height:CGFloat = 30
    
    convenience init() {
        self.init(x:0, y:0)
    }
    
    init(x:CGFloat, y:CGFloat) {
        super.init(frame: CGRect(x:x, y:y, width:width, height:height))
        self.layer.cornerRadius = 15
        self.setTitle("关注", forState: UIControlState.Normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(colorString: "#555555").CGColor
        self.setTitleColor(UIColor(colorString: "#555555"), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(12)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPosition(x:CGFloat, y:CGFloat){
        let oldFrame = self.frame
        self.frame = CGRect(x:x, y:y, width:oldFrame.width, height:oldFrame.height)
    }
}
