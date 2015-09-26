//
//  PropertyCommentButton.swift
//  alltuu
//
//  Created by MAC on 15/9/25.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//


import UIKit

class PropertyCommentButton: PropertyButton {
    init(labelText:String){
        super.init(labelText:labelText, iconFont:"\u{e621}")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}