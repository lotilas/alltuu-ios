//
//  PhotographerBarButton.swift
//  alltuu
//
//  Created by MAC on 15/9/15.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation

//
//  SeperateBarButton.swift
//  alltuu
//
//  Created by MAC on 15/9/14.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit
import Haneke


class PhotographerBarButton: UIButton {
    
    let fontColor = "#000000"
    let fontSize:CGFloat = 17

    let defaultWidthToAutoResize:CGFloat = 0
    let marginBetweenAvatarAndName:CGFloat = 5
    let avatarSize:CGFloat = 34
    let buttonHeight:CGFloat = 34
    let marginTopOfNameLabel:CGFloat = 6
    let nameLabelHeight:CGFloat = 17
    
    var photographerAvatarView:UIImageView?
    var photographerNameLaber:UILabel?
    
    var photographer:Photographer?
    
    init(photographer:Photographer){
        super.init(frame: CGRect(x: 0.0, y: 0.0,width: defaultWidthToAutoResize, height: buttonHeight))
        self.photographer = photographer
        
        // Avatar
        photographerAvatarView = UIImageView(frame:CGRect(x: 0,y: 0,width: avatarSize,height: avatarSize))
        photographerAvatarView!.layer.masksToBounds = true
        photographerAvatarView!.layer.cornerRadius = avatarSize/2
        
        photographerAvatarView!.loadImageThroughCache("\(self.photographer!.url)@\(Int(Float(self.avatarSize))*2)w", placeHolder:UIImage(named: "photographer"), cacheKey: self.photographer!.toCacheKey(), cacheExpire: AtCacheManager.A_MINUTE*2)

        self.addSubview(self.photographerAvatarView!)
        
        // Name
        photographerNameLaber = UILabel()
        photographerNameLaber!.text = self.photographer?.name
        photographerNameLaber!.frame = CGRect(x: avatarSize + marginBetweenAvatarAndName, y: marginTopOfNameLabel, width: defaultWidthToAutoResize, height: nameLabelHeight)
        photographerNameLaber?.font = UIFont.systemFontOfSize(fontSize)
        photographerNameLaber?.textColor = UIColor(colorString: fontColor)
        photographerNameLaber?.sizeToFit()
        self.addSubview(self.photographerNameLaber!)

        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: photographerAvatarView!.frame.width + marginBetweenAvatarAndName + photographerNameLaber!.frame.width, height: self.frame.height)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPosition(x:CGFloat, y:CGFloat){
        self.frame = CGRect(x:x, y:y, width:self.frame.width, height:self.frame.height)
    }
    
    func toCacheKey() -> String{
        return "PGImage-\(self.photographer!.id)"
    }
}
