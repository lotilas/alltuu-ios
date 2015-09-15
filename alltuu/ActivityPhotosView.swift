//
//  ActivityPhotosView.swift
//  alltuu
//
//  Created by MAC on 15/9/11.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class ActivityPhotosView: AtCollectionView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor(colorString: "#F6F6F6").CGColor
    }
}
