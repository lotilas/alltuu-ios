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
        let cache = Shared.imageCache
        
        // set cell properties
        let cacheKey = self.photo!.toCacheKey()
        
        cache.fetch(key: cacheKey).onSuccess { image in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.photoView.image = image
            }
            }.onFailure {failer in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.photoView.image = UIImage(named: "loading.jpg")
                }
                
                let urlStr = self.photo!.url
                
                // load image
                if let imageURL = NSURL(fileURLWithPath: urlStr) {
                    let qos = Int(QOS_CLASS_USER_INITIATED.value)
                    let q = dispatch_get_global_queue(qos, 0)
                    dispatch_async(q) { () -> Void in
                        if let imageData = NSData(contentsOfURL: NSURL(string: urlStr)!){
                            if self.photo != nil{
                                self.photo!.downloaded = true
                            }
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                                println("\(NSDate()) LOAD END \(self.photo!.id)")
                                self.photoView.image = UIImage(data: imageData)
                            }
                            cache.set(value: UIImage(data:imageData)!, key: cacheKey)
                        }
                    }
                }
        }
    }

}