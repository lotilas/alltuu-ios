//
//  ActivityView.swift
//  Smashtag
//
//  Created by MAC on 15/9/8.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class ActivityView: UICollectionView {
    //MARK: LoadMore
    //上拉加载更多
    func toLoadMoreAction(action :(() -> Void)){
        var footView = ZLSwiftFootView(action: action, frame: CGRectMake( 0 , UIScreen.mainScreen().bounds.size.height - ZLSwithRefreshFootViewHeight, self.frame.size.width, ZLSwithRefreshFootViewHeight))
        footView.tag = ZLSwiftFootViewTag
        self.addSubview(footView)
    }
    
    //一次加载完毕
    func didLoadMore(){
        refreshStatus = .Normal
    }
    
    //数据加载完毕
    func didLoadAll() {
        var footView:ZLSwiftFootView = self.viewWithTag(ZLSwiftFootViewTag) as! ZLSwiftFootView
        footView.isEndLoadMore = true
        didLoadMore()
    }
}
