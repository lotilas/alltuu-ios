//
//  AtCollectionView.swift
//  提供了LoadMore的方法
//  alltuu
//
//  Created by MAC on 15/9/11.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class AtCollectionView: UICollectionView {
    var footView:AtLoadMoreFootView?
    
    //MARK: LoadMore
    //上拉加载更多
    func initLoadMoreFootView(action :(() -> Void), noMoreText:String){
        self.initLoadMoreFootView(action, defaultText:"上拉加载更多", loadingText:"加载中...", noMoreText:noMoreText)
    }
    
    func initLoadMoreFootView(action :(() -> Void), defaultText:String, loadingText:String, noMoreText:String ){
        footView = AtLoadMoreFootView(action: action, frame: CGRectMake( 0 , UIScreen.mainScreen().bounds.size.height - AtLoadMoreFootView.height, UIScreen.mainScreen().bounds.size.width, AtLoadMoreFootView.height))
        footView!.defaultText = defaultText
        footView!.loadingText = loadingText
        footView!.noMoreText = noMoreText
    }
    
    func hideFootView(){
        footView!.removeFromSuperview()
    }
    
    func showFootView(){
        self.addSubview(footView!)
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
