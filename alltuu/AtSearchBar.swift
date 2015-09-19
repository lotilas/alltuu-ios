//
//  AtSearchBar.swift
//  alltuu
//
//  Created by MAC on 15/9/17.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class AtSearchBar: UISearchBar {

    
    override func awakeFromNib() {
        for view in self.subviews {
            (view as! UIView).subviews[0].removeFromSuperview()
        }
        self.backgroundColor = UIColor(colorString: "#F0F0F0")
    }
}
