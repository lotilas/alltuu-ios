//
//  NavigationBackgroundView.swift
//  alltuu
//
//  Created by MAC on 15/9/15.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class AtNavigationView: UIView {
    
    var titleLabel:UILabel?
    
    var statusBarHeight:CGFloat
    
    init(navigationViewFrame:CGRect, statusBarFrame:CGRect){
        statusBarHeight = statusBarFrame.height
        super.init(frame: CGRect(x:0, y:-statusBarHeight, width:navigationViewFrame.width, height:navigationViewFrame.height + statusBarHeight))
        self.userInteractionEnabled = false
        self.backgroundColor = UIColor(colorString: AtColor.BlueNormal.rawValue)
        titleLabel = UILabel()
        titleLabel!.textColor = UIColor.whiteColor()
        titleLabel!.font = UIFont.systemFontOfSize(18)
        self.addSubview(titleLabel!)
    }

    required init(coder aDecoder: NSCoder) {
        statusBarHeight = 0
        super.init(coder: aDecoder)
    }
    
    func setTitle(title:String){
        titleLabel!.text = title
        titleLabel!.sizeToFit()
        titleLabel!.frame = CGRect(x: (self.frame.width-titleLabel!.frame.width)/2,y: statusBarHeight/2,width: titleLabel!.frame.width, height: self.frame.height)
        titleLabel!.backgroundColor = UIColor.clearColor()
    }
}
