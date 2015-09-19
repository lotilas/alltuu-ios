//
//  AtTableView.swift
//  alltuu
//
//  Created by MAC on 15/9/16.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class AtTableView: UITableView {
    
    var footView:AtLoadMoreFootView?
    
    //MARK: LoadMore
    //上拉加载更多
    func initLoadMoreFootView(action :(() -> Void)){
        footView = AtLoadMoreFootView(action: action, frame: CGRectMake( 0 , UIScreen.mainScreen().bounds.size.height - AtLoadMoreFootView.height, UIScreen.mainScreen().bounds.size.width, AtLoadMoreFootView.height))
        footView!.alpha = 1
    }
    
    func hideFootView(){
        footView!.removeFromSuperview()
    }
    
    func showFootView(){
        self.addSubview(footView!)
    }
    
    func setFootViewNoMoreTitle(title:String){
        self.footView!.noMoreText = title
    }
    
    //一次加载完毕
    func didLoadMore(){
        refreshStatus = .Normal
    }
    
    //数据加载完毕
    func didLoadAll() {
        footView!.isEndLoadMore = true
        didLoadMore()
    }

}
