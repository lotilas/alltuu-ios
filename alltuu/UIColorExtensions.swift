//
//  ColorUtils.swift
//  alltuu
//
//  Created by MAC on 15/9/14.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(colorString : String) {
        self.init(colorString:colorString, alpha:1.0)
    }
    
    convenience init(colorString : String , alpha : CGFloat) {
        if colorString.substringToIndex(advance(colorString.startIndex, 1))=="#" && count(colorString) == 7{
            var redHexString = colorString.substringWithRange(Range(start: advance(colorString.startIndex,1),end: advance(colorString.startIndex, 3)))
            var greenHexString = colorString.substringWithRange(Range(start: advance(colorString.startIndex,3),end: advance(colorString.startIndex, 5)))
            var blueHexString = colorString.substringWithRange(Range(start: advance(colorString.startIndex,5),end: advance(colorString.startIndex, 7)))
            var redInt:UInt32 = 0
            var redResult = NSScanner(string: redHexString).scanHexInt(&redInt)
            var greenInt:UInt32 = 0
            var greenResult = NSScanner(string: greenHexString).scanHexInt(&greenInt)
            var blueInt:UInt32 = 0
            var blueResult = NSScanner(string: blueHexString).scanHexInt(&blueInt)
            if redResult && greenResult && blueResult {
                var red = CGFloat(redInt) / 255
                var green = CGFloat(greenInt) / 255
                var blue = CGFloat(blueInt) / 255
                self.init(red: red, green: green, blue: blue, alpha: alpha)
            } else {
                println("ERROR Web Color String:\(colorString) with alpha:\(alpha)")
                self.init()
            }
        } else {
            println("ERROR Web Color String:\(colorString) with alpha:\(alpha)")
            self.init()
        }
    }
    
}
