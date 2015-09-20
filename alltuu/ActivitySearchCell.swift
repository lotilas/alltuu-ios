//
//  ActivitySearchCell.swift
//  alltuu
//
//  Created by MAC on 15/9/16.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class ActivitySearchCell: UITableViewCell {

    @IBOutlet weak var activityImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var lockView: UIImageView!
    
    @IBOutlet weak var cellContentView: UIImageView!
    var activity:Activity? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        self.activityImageView.image = UIImage(named: "loading.jpg")
        cellContentView.layer.borderWidth = 1
        cellContentView.layer.borderColor = UIColor(colorString: "#DDDDDD").CGColor
        if (self.activity!.needPassword) {
            self.lockView.alpha = 1.0
        } else {
            self.lockView.alpha = 0.0
        }
        self.layer.backgroundColor = UIColor(colorString: "#F0F0F0").CGColor
        titleLabel.text = activity!.title
        subtitleLabel.text = "\(activity!.adateDot) | \(activity!.city)"
        let url = "http://pub.alltuu.com/act/\(self.activity!.id)-o.jpg@1e_324w_234h_1c_0i_1o_90Q_1x.jpg"
        activityImageView.hnk_setImageFromURL(NSURL(string:url)!, success:{i in
            self.activityImageView.image = i
        },failure:{ failure in
                println("F : \( failure?.description)")
        })
    }
    
    
}
