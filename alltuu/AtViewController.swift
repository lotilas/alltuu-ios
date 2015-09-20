//
//  AtViewController.swift
//  alltuu
//
//  Created by MAC on 15/9/11.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class AtViewController: UIViewController {
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //改变按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //改变状态栏字体颜色
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent,animated: false)
        //改变整体背景颜色
        checkAtNavigationView()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    var navigationView:AtNavigationView?
    
    func checkAtNavigationView(){
        var exist = false
        for subview in self.view.subviews {
            if subview is AtNavigationView {
                exist = true
                self.navigationView = subview as? AtNavigationView
            }
        }
        if !exist {
            var navigationView = AtNavigationView(navigationViewFrame: self.navigationController!.navigationBar.frame, statusBarFrame:UIApplication.sharedApplication().statusBarFrame)
            self.navigationController?.navigationBar.addSubview(navigationView)
            self.navigationView = navigationView
        }
    }
}
