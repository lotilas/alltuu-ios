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
    
    
    
    public var activity : Activity? {
        didSet {
            updateUI()
        }
    }
    
    public override func removeFromSuperview() {
//        println("remove")
    }
    
    func updateUI(){
        let cache = Shared.imageCache
        
        // set cell properties
        activityTitle.text = activity!.title
        activityAddr.text = activity!.addr
        if activity!.needPassword {
            activityImage.alpha = 0.5
        } else {
            activityImage.alpha = 1.0
        }
                
        let cacheKey = activity!.toCachedKey()
        
        cache.fetch(key: cacheKey).onSuccess { image in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityImage.image = image
            }
        }.onFailure {failer in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.activityImage.image = UIImage(named: "loading.jpg")
            }
        
            let urlStr = "http://pub.alltuu.com/act/\(self.activity!.id)-o.jpg@1e_320w_240h_1c_0i_1o_90Q_1x.jpg"
            
            // load image
            if let imageURL = NSURL(fileURLWithPath: urlStr) {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                let q = dispatch_get_global_queue(qos, 0)
                dispatch_async(q) { () -> Void in
                    if let imageData = NSData(contentsOfURL: NSURL(string: urlStr)!){
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                            println("\(NSDate()) LOAD END \(self.activity!.id)")
                            self.activityImage.image = UIImage(data: imageData)
                        }
                        cache.set(value: UIImage(data:imageData)!, key: cacheKey)
                    }
                }
            }
        }
    }
    
    

}
