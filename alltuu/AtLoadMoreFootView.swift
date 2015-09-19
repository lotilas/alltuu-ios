//
//  AtLoadMoreFootView.swift
//  alltuu
//
//  Created by MAC on 15/9/16.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

public class AtLoadMoreFootView: UIView {
    
    public static let viewTag = 102
    public static let height:CGFloat = 40
    
    
    let contentOffsetKeyPath = "contentOffset"
    let contentSizeKeyPath = "contentSize"
    
    var defaultText = ""
    var noMoreText  = ""
    var loadingText  = ""
    
    
    var scrollView:UIScrollView = UIScrollView()
    var footLabel: UILabel = UILabel()
    
    var loadMoreAction: (() -> Void) = {}
    var loadMoreTempAction:(() -> Void) = {}
    
    var KVOContext = "" {
        willSet{
            
        }
    }
    
    var isEndLoadMore:Bool = false{
        willSet{
            self.footLabel.text = noMoreText
            self.isEndLoadMore = newValue
        }
    }
    var title:String {
        set {
            footLabel.text = newValue
        }
        
        get {
            return footLabel.text!
        }
    }
    
    convenience init(action: (() -> ()), frame: CGRect){
        self.init(frame: frame)
        self.loadMoreAction = action
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        self.setupUI()
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Currently it is not supported to load view from nib
    }
    
    func setupUI(){
        var footTitleLabel:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        //        println("\(self.frame.size.width)")
        footTitleLabel.textAlignment = .Center
        footTitleLabel.text = defaultText
        self.addSubview(footTitleLabel)
        footLabel = footTitleLabel
    }
    
    public override func willMoveToSuperview(newSuperview: UIView!) {
        superview?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &KVOContext)
        superview?.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &KVOContext)
        if newSuperview != nil && newSuperview.isKindOfClass(UIScrollView) {
            self.scrollView = newSuperview as! UIScrollView
            
            self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom + self.frame.height + self.frame.height * 0.5 + self.scrollView.frame.origin.y, self.scrollView.contentInset.right)
            
            newSuperview.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .Initial, context: &KVOContext)
            newSuperview.addObserver(self, forKeyPath: contentSizeKeyPath, options: .Initial, context: &KVOContext)
        }
    }
    
    //MARK: Observer handler
    
    // 滚动事件的观察者
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        
        if self.loadMoreAction == nil {
            return;
        }
        
        var scrollView:UIScrollView = self.scrollView
        if keyPath == contentSizeKeyPath {
            // change contentSize
            if scrollView.isKindOfClass(UICollectionView) == true {
                let tempCollectionView :UICollectionView = scrollView as! UICollectionView
                var height = tempCollectionView.collectionViewLayout.collectionViewContentSize().height
                self.frame.origin.y = height
            } else {
                if self.scrollView.contentSize.height == 0 {
                    self.removeFromSuperview()
                } else if(scrollView.contentSize.height < self.frame.size.height){
                    self.frame.origin.y = self.scrollView.frame.size.height - self.frame.height
                } else {
                    self.frame.origin.y = scrollView.contentSize.height
                }
            }
            
            self.frame.origin.y += AtLoadMoreFootView.height * 0.5
            
            return;
        }
        
        // change contentOffset
        var scrollViewContentOffsetY:CGFloat = scrollView.contentOffset.y
        
        // 上拉加载更多
        if scrollViewContentOffsetY > 0 {
            var nowContentOffsetY:CGFloat = scrollViewContentOffsetY + self.scrollView.frame.size.height
            var tableViewMaxHeight:CGFloat = 0
            
            if scrollView.isKindOfClass(UICollectionView) {
                let tempCollectionView :UICollectionView = scrollView as! UICollectionView
                var height = tempCollectionView.collectionViewLayout.collectionViewContentSize().height
                tableViewMaxHeight = height
            } else if (scrollView.contentSize.height > 0){
                tableViewMaxHeight = scrollView.contentSize.height
            }
            
            if refreshStatus == .Normal {
                loadMoreTempAction = loadMoreAction
            }
            
            if (nowContentOffsetY - tableViewMaxHeight) > 0 && scrollView.contentOffset.y != 0 {
                if isEndLoadMore == false && refreshStatus == .Normal {
                    if loadMoreTempAction != nil{
                        refreshStatus = .LoadMore
                        self.title = loadingText
                        loadMoreTempAction()
                        loadMoreTempAction = {}
                    } else {
                        self.title = noMoreText
                    }
                }
            } else if isEndLoadMore == false {
                loadMoreTempAction = loadMoreAction
                self.title = defaultText
            }
        } else if isEndLoadMore == false {
            self.title = defaultText
        }
    }
}
