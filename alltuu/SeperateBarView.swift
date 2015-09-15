//
//  SeperateBarView.swift
//  alltuu
//
//  Created by MAC on 15/9/14.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class SeperateBarView: UIScrollView {

    var barHeight:CGFloat = 38
    var currentWidth:CGFloat = 6
    var buttomMargin:CGFloat = 5
    var marginTop:CGFloat = 5
    
    var buttonGroup = Array<SeperateBarButton>()
    
    var seperateSwitchDelegate:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor(colorString: "#E3E3E3").CGColor
        self.layer.backgroundColor = UIColor(colorString: "#F6F6F6").CGColor
    }
    
    override func addSubview(view: UIView) {
        super.addSubview(view)
        if let v = view as? SeperateBarButton {
            buttonGroup.append(v)
            v.addTarget(self.seperateSwitchDelegate, action: "onSeperateSwitch:", forControlEvents: UIControlEvents.TouchUpInside)
            v.setPosition(currentWidth, y: self.marginTop)
            currentWidth = currentWidth + v.frame.width + self.buttomMargin
            self.contentSize = CGSize(width:currentWidth, height:barHeight)
        }
    }
    
    func highlightButton(button:SeperateBarButton){
        for btn in buttonGroup {
            if btn == button {
                btn.highlight(true)
            } else {
                btn.highlight(false)
            }
        }
    }
    
    func highlightButtonAt(index:Int){
        let button = buttonGroup[index]
        for btn in self.buttonGroup {
            if btn == button {
                btn.highlight(true)
            } else {
                btn.highlight(false)
            }
        }
        
    }
}
