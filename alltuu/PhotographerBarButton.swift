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
        
        let cache = Shared.imageCache
        cache.fetch(key: self.toCacheKey()).onSuccess { image in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.photographerAvatarView!.image = image
            }
        }.onFailure {failer in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.photographerAvatarView!.image = UIImage(named: "photographer")
                }
                let url = self.photographer!.url
                // load image
                if let imageURL = NSURL(fileURLWithPath: url) {
                    let qos = Int(QOS_CLASS_USER_INITIATED.value)
                    let q = dispatch_get_global_queue(qos, 0)
                    dispatch_async(q) { () -> Void in
                        if let imageData = NSData(contentsOfURL: NSURL(string: "\(url)@\(Int(Float(self.avatarSize))*2)w")!){
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                self.photographerAvatarView!.image = UIImage(data: imageData)
                            }
                            cache.set(value: UIImage(data:imageData)!, key: self.toCacheKey())
                        }
                    }
                }
        }

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
