//
//  PhotographerBarView.swift
//  alltuu
//
//  Created by MAC on 15/9/14.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class PhotographerBarView: UIScrollView {

    let barHeight:CGFloat = 54
    let buttomMargin:CGFloat = 15
    let marginTop:CGFloat = 9
    let initX:CGFloat = 12
    
    var currentWidth:CGFloat = 0
    
    var buttonGroup = Array<PhotographerBarButton>()
    
    var seperateSwitchDelegate:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentWidth = initX
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor(colorString: "#E3E3E3").CGColor
        self.layer.backgroundColor = UIColor(colorString: "#F6F6F6").CGColor
    }
    
    override func addSubview(view: UIView) {
        super.addSubview(view)
        if let v = view as? PhotographerBarButton {
            buttonGroup.append(v)
            v.addTarget(self.seperateSwitchDelegate, action: "onPhotographerClick:", forControlEvents: UIControlEvents.TouchUpInside)
            v.setPosition(currentWidth, y: self.marginTop)
            currentWidth = currentWidth + v.frame.width + self.buttomMargin
            self.contentSize = CGSize(width:currentWidth, height:barHeight)
        }
    }
    
    func removeAllPhotographers(){
        currentWidth = initX
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
