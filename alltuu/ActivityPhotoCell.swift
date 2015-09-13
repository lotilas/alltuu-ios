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
    
    func updateUI(){
        self.frame = CGRect(x:self.frame.origin.x,y:self.frame.origin.y,width:self.photo!.size.width,height:self.photo!.size.height)
        self.photoView.frame = CGRect(x:self.frame.origin.x,y:self.frame.origin.y,width:self.photo!.size.width,height:self.photo!.size.height)
//        println("UI UPDATE:\(self.photo!.id)")
        self.backgroundColor = UIColor.blackColor()
        let cache = Shared.imageCache
        
        // set cell properties
        let cacheKey = self.photo!.toCacheKey()
        
        cache.fetch(key: cacheKey).onSuccess { image in
                        println("CELL:\(cacheKey) cached")
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.photoView.image = image
            }
        }.onFailure {failer in
                        println("CELL:\(cacheKey) not cached")
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.photoView.image = UIImage(named: "loading.jpg")
            }        
        }
    }

}