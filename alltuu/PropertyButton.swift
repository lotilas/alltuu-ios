//
//  PropertyView.swift
//  alltuu
//
//  Created by MAC on 15/9/25.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class PropertyButton: UIButton{
    
    let initialButtonWidth:CGFloat = 100
    let initialButtonHeight:CGFloat = 100
    
    let iconWidth:CGFloat = 24
    let iconHeight:CGFloat = 24
    
    let initialLabelWidth:CGFloat = 24
    let initialLabelHeight:CGFloat = 24
    
    let marginBetweenIconAndLabel:CGFloat = 8
    let labelMarginTop:CGFloat = 3
    
    var icon:UILabel?
    var label:UILabel?
    var innerLayoutView:UIView?
    
    init(labelText:String? = nil, iconFont:String? = nil){
        super.init(frame: CGRect(x:0,y:0,width:initialButtonWidth,height:initialButtonHeight))
        
        self.addTarget(self, action: "onTouchDown", forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: "onTouchUpInside", forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: "onTouchUpOutside", forControlEvents: UIControlEvents.TouchUpOutside)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(colorString: AtColor.BorderLightGray.rawValue).CGColor
        innerLayoutView = UIView(frame: CGRect(x:0,y:0,width:initialButtonWidth,height:initialButtonHeight))
        innerLayoutView!.userInteractionEnabled = false
        var width:CGFloat = 0
        if let iconText = iconFont {
            icon = UILabel(frame: CGRect(x:0, y:0, width:iconWidth, height:iconHeight))
            icon!.userInteractionEnabled = false
            icon!.font = AtFontIcon.getFont(24)
            icon!.text = iconText
            icon!.textColor = UIColor(colorString: AtColor.IconFontDarkGray.rawValue)
            innerLayoutView!.addSubview(icon!)
            icon!.sizeToFit()
            width += icon!.frame.width
        }
        if let text = labelText {
            var initialLabelX:CGFloat = 0
            if icon != nil {
                initialLabelX = icon!.frame.width
            }
            label = UILabel(frame: CGRect(x:initialLabelX + marginBetweenIconAndLabel,y:labelMarginTop, width:initialLabelWidth, height:initialLabelHeight))
            label!.userInteractionEnabled = false
            label!.text = text
            label!.textColor = UIColor(colorString: AtColor.IconFontDarkGray.rawValue)
            innerLayoutView!.addSubview(label!)
            label!.font = UIFont.systemFontOfSize(14)
            label!.sizeToFit()
            width += label!.frame.width + marginBetweenIconAndLabel
            
        }
        let of = innerLayoutView!.frame
        innerLayoutView!.frame = CGRect(x:of.origin.x, y:of.origin.y, width:width, height:iconWidth)
        self.addSubview(innerLayoutView!)
        self.centerInnerLayout()
    }
    
    func updateLabelText(newText:String){
        var width:CGFloat = 0
        if icon != nil {
            width += icon!.frame.width
        }
        if label != nil {
            label!.text = newText
            label!.sizeToFit()
            let of = innerLayoutView!.frame
            width += label!.frame.width + marginBetweenIconAndLabel
            innerLayoutView!.frame = CGRect(x:of.origin.x, y:of.origin.y, width:width, height:iconWidth)
        }
    }
    
    func centerInnerLayout(){
        let nc = CGPoint(x:self.frame.width/2, y:self.frame.height/2)
        UIView.animateWithDuration(0.25, animations: {
            self.innerLayoutView!.center = nc
        })
    }
    
    func onTouchDown(){
        dispatch_async(dispatch_get_main_queue()){
            self.layer.backgroundColor = UIColor(colorString: AtColor.BlueActive.rawValue).CGColor
            println("D")
        }
    }
    
    func onTouchUpInside(){
        dispatch_async(dispatch_get_main_queue()){
            self.layer.backgroundColor = UIColor.whiteColor().CGColor
            println("I")
        }
    }
    
    func onTouchUpOutside(){
        dispatch_async(dispatch_get_main_queue()){
            self.layer.backgroundColor = UIColor.whiteColor().CGColor
            println("O")
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}