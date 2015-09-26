//
//  AtFontIcon.swift
//  alltuu
//
//  Created by MAC on 15/9/25.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

public enum FontIconType:String {
    case Property_Like = "\u{e620}"
    case Property_Comment = "\u{e621}"
    case Property_Share = "\u{e622}"
    case Property_Download = "\u{e623}"
}


public class AtFontIcon {
    static let fontFamilyName = "iconfont"
    
    public static func getFont(size:CGFloat) -> UIFont{
        var a = UIFont()
        return UIFont(name:fontFamilyName , size: size)!
    }
    
}