//
//  PhotoDetailCard.swift
//  alltuu
//
//  Created by MAC on 15/9/20.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class PhotoDetailCard: UIView {

    // 中间的大图
    var detailImageUImage:UIImage? {
        get {
            return detailImageView!.image
        }
        set {
            detailImageView!.image = newValue
        }
    }
    var detailImageView: UIImageView?
    var photographerAvatar:PhotographerBarButton?
    var followButton:FollowPhotographerButton?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
