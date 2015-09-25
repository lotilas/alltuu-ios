//
//  ActivityCell.swift
//  Alltuu
//
//  Created by MAC on 15/9/8.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit
import Haneke


public class ActivityCell: UICollectionViewCell {
    
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var activityTitle: UILabel!
    
    @IBOutlet weak var activityAddr: UILabel!
    
    @IBOutlet weak var lockView: UIImageView!
    
    
    public var activity : Activity? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        let cache = Shared.imageCache
        
        // set cell properties
        activityTitle.text = activity!.title
        activityAddr.text = activity!.addr
        if activity!.needPassword {
            lockView.alpha = 1.0
        } else {
            lockView.alpha = 0.0
        }
                
        let cacheKey = activity!.toCachedKey()
        
        self.activityImage.loadImageThroughCache("http://pub.alltuu.com/act/\(self.activity!.id)-o.jpg@1e_320w_240h_1c_0i_1o_90Q_1x.jpg", cacheKey: cacheKey, cacheExpire: AtCacheManager.A_DAY)
    }
}
