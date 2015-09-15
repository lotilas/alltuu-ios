//
//  SeperateBarButton.swift
//  alltuu
//
//  Created by MAC on 15/9/14.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class SeperateBarButton: UIButton {
    
    
    enum ButtonColor:String {
        case NORMAL = "#F6F6F6"
        case ACTIVE = "#3DB8BC"
    }
    
    enum FontColor:String {
        case NORMAL = "#111111"
        case ACTIVE = "#FFFFFF"
    }
    
    var sepId:Int = 0
    
    init(titleText:String, sepId:Int){
        super.init(frame: CGRect(x: 0.0, y: 0.0,width: 100.0,height: 26.0))
        self.sepId = sepId
        self.setTitle(titleText, forState: UIControlState.Normal)
        self.layer.cornerRadius = 13.0
        
        self.titleLabel!.font = UIFont.systemFontOfSize(12)
        self.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        self.sizeToFit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setBackgroundColor(color:ButtonColor){
        self.backgroundColor = UIColor(colorString:color.rawValue)
    }
    
    func setFontColor(color:FontColor){
        self.titleLabel?.textColor = UIColor(colorString:color.rawValue)
    }
    
    func highlight(shouldHighlight:Bool){
        if shouldHighlight {
            setBackgroundColor(ButtonColor.ACTIVE)
                    self.setTitleColor(UIColor(colorString: FontColor.ACTIVE.rawValue), forState: UIControlState.Normal)
        } else {
            setBackgroundColor(ButtonColor.NORMAL)
                    self.setTitleColor(UIColor(colorString: FontColor.NORMAL.rawValue), forState: UIControlState.Normal)
        }
    }
    
    func setPosition(x:CGFloat, y:CGFloat){
        self.frame = CGRect(x:x, y:y, width:self.frame.width, height:self.frame.height)
    }
}
