//
//  MyLayout.swift
//  ActivityPhotosViewLayout
//
//  Created by  tsou117 on 15/7/6.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

import Foundation
import UIKit


@objc protocol WaterFallLayoutDelegate{
    
    func collectionView(collectionview:UICollectionView,layout:UICollectionViewLayout,indexPath:NSIndexPath) ->CGSize
    
}

class ActivityPhotosViewLayout: UICollectionViewLayout {
    //
    var delegate:WaterFallLayoutDelegate?
    
    //
    
    var x = CGFloat()
    var leftY = CGFloat()
    var rightY = CGFloat()
    var YY = CGFloat()
    //
    var itemwidth = CGFloat()
    var center = CGPoint()
    var radius = CGFloat()
    let sectionInset = UIEdgeInsets(top: 60 ,left: 0,bottom: 8,right: 0)
    
    
    override func prepareLayout() {
        //
        super.prepareLayout()
        
        var size = self.collectionView!.frame.size
        self.itemwidth = (size.width-8)/2
        self.delegate = self.collectionView!.delegate as! WaterFallLayoutDelegate?
        center = CGPointMake(size.width*0.5, size.height*0.5)
        radius = min(size.width, size.height)/2.5
    }
    
    override func collectionViewContentSize() -> CGSize {
        var nowH = leftY > rightY ? leftY : rightY
        return CGSizeMake(self.collectionView!.frame.size.width, nowH)
    }
    
    func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath,index:NSInteger) -> UICollectionViewLayoutAttributes! {
        //
        var itemsize = self.delegate?.collectionView(self.collectionView!, layout: self, indexPath: indexPath)
        var itemheight = floor(itemsize!.height*itemwidth/itemsize!.width)
        
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var nowindex = index
        
        if (nowindex%2 == 0){
            //
            x += (itemwidth + sectionInset.left)
            rightY += sectionInset.top
            attributes.frame = CGRectMake(x, rightY, itemwidth, itemheight)
            rightY += itemheight
            
        }else if (nowindex%2 == 1){
            //
            x = sectionInset.left
            leftY += sectionInset.top
            //println("nowIndex:\(nowindex) x:\(x) leftY:\(leftY) itemWidth:\(itemwidth), itemHeight:\(itemheight)")
            attributes.frame = CGRectMake(x, leftY, itemwidth, itemheight)
            leftY += itemheight
        }
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        x = 0.0
        leftY = 0.0
        rightY = 0.0
        
        var layoutAttributes = NSMutableArray()
        let sectionCount = self.collectionView?.numberOfSections()
        var index = 0
        for var indexOfSection = 0; indexOfSection < sectionCount; indexOfSection++ {
            let itemInSectionCount = self.collectionView?.numberOfItemsInSection(indexOfSection)
            for var indexOfItemInSection = 0; indexOfItemInSection < itemInSectionCount; indexOfItemInSection++ {
                var indexPath = NSIndexPath(forItem: indexOfItemInSection, inSection: indexOfSection)
                //println("\(indexPath.section) : \(indexPath.item)")
                layoutAttributes.addObject((layoutAttributesForItemAtIndexPath(indexPath, index: index++)))
            }
        }
        return layoutAttributes as [AnyObject]
    }
    
    
    
    
}