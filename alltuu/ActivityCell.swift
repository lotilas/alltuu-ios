//
//  ActivityCell.swift
//  Smashtag
//
//  Created by MAC on 15/9/8.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

public class ActivityCell: UICollectionViewCell {
    
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var activityTitle: UILabel!
    
    @IBOutlet weak var activityAddr: UILabel!
    
    public var activity : Activity? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        activityTitle.text = activity!.title
        activityAddr.text = activity!.addr
        let activityImageName = "activity/\(activity!.id)-cover.jpg"
        activityImage.image = UIImage(named: "loading.jpg")
        if let imageData = NSData(contentsOfURL: NSURL(fileURLWithPath: activityImageName)!){
            if let image = UIImage(data: imageData) {
                println("OK")
            } else {
                println("NO IMAGE")
            }
        } else {
            println("NOT EXIST")
        }
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        let q = dispatch_get_global_queue(qos, 0)
        dispatch_async(q) { () -> Void in
            println("START:\(NSDate())")
            if let imageData = NSData(contentsOfURL: NSURL(string: "http://pub.alltuu.com/act/\(self.activity!.id)-o.jpg@1e_320w_240h_1c_0i_1o_90Q_1x.jpg")!){
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.activityImage.image = UIImage(data: imageData)
                }
                var a = imageData.writeToURL(NSURL(fileURLWithPath: activityImageName)!, atomically: true)
                println("\(activityImageName)")
                println("write done: \(a)")
            }
            println("END:\(NSDate())")
            println("")
        }
    }

}
