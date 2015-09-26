//
//  DetailPropertyButtonGroup.swift
//  alltuu
//
//  Created by MAC on 15/9/25.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class DetailPropertyButtonGroup : UIView {
    
    
    var buttons = Array<PropertyButton>()
    
    func appendPropertyButton(newButton:PropertyButton){
        buttons.append(newButton)
        self.addSubview(newButton)
    }
    
    func layoutAllButtons(){
        if buttons.count > 0 {
            let width = self.frame.width/CGFloat(Float(self.buttons.count))
            var x:CGFloat = 0
            var of:CGRect
            var index:Int = 0
            for var index=0; index<buttons.count; index++ {
                if index != (buttons.count-1) {
                    buttons[index].frame = CGRect(x:x, y:0, width:width, height:self.frame.height)
                    x += width
                } else {
                    //最后一个
                    buttons[index].frame = CGRect(x:x, y:0, width:self.frame.width - x, height:self.frame.height)
                }
                buttons[index].centerInnerLayout()
            }
        }
    }
}
