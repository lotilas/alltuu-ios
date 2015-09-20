//
//  ActivityPhotoCell.swift
//  alltuu
//
//  Created by MAC on 15/9/11.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit
import Haneke

public class ActivityPhotoCell: UICollectionViewCell {
    
    @IBOutlet var photoView: UIImageView!
    
    public var photo : ActivityPhoto? {
        didSet {
            //println("\(photo.description())")
            updateUI()
        }
    }
    
    override public func awakeFromNib() {
        self.layer.backgroundColor = UIColor(colorString: "#F6F6F6").CGColor
        self.photoView.layer.backgroundColor = UIColor(colorString: "#F6F6F6").CGColor
    }
    
    func updateUI(){
        let cache = Shared.imageCache
        
        self.photoView.loadImageThroughCache(self.photo!.url, cacheKey: self.photo!.toCacheKey(), cacheExpire: AtCacheManager.A_WEEK)
    }

}