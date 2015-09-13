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
    
    var x:CGFloat = 0.0
    var leftY:CGFloat = 0.0
    var rightY:CGFloat = 0.0
    var YY = CGFloat()
    //
    var itemWidth = CGFloat()
    var center = CGPoint()
    var radius = CGFloat()
    var colMagrin:CGFloat = 4.0
    let sectionInset = UIEdgeInsets(top: 5 ,left: 5,bottom: 5,right: 5)
    let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
    var layoutDic = Dictionary<String,CGRect>()
    
    override func prepareLayout() {
        //
        super.prepareLayout()
        
        var size = self.collectionView!.frame.size
        self.itemWidth = (size.width-13)/2
//        println("\(self.itemWidth)")
        self.delegate = self.collectionView!.delegate as! WaterFallLayoutDelegate?
        center = CGPointMake(size.width*0.5, size.height*0.5)
        radius = min(size.width, size.height)/2.5
        
    }
    
    override func collectionViewContentSize() -> CGSize {
        var nowHight = leftY > rightY ? leftY : rightY
        return CGSizeMake(self.collectionView!.frame.size.width, nowHight)
    }
    
    func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath,index:NSInteger) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        if let thisFrame = self.layoutDic["\(indexPath.section)-\(indexPath.item)"] {
            attributes.frame = thisFrame
//            println("C:\(indexPath.item) \t\(attributes.frame.width),\t\(attributes.frame.height),\tAT\t\(attributes.frame.origin.x),\t\(attributes.frame.origin.y)")
        } else {
            // 计算高度
            var itemSize = self.delegate?.collectionView(self.collectionView!, layout: self, indexPath: indexPath)
            var itemHeight = floor(itemSize!.height * self.itemWidth / itemSize!.width)
            
            var nowY = CGFloat()
            var nowX = CGFloat()
            // Col right
            if self.leftY > self.rightY {
                nowY = self.rightY
                nowX = self.sectionInset.left + self.itemWidth + self.colMagrin
                self.rightY = self.rightY + itemHeight + self.sectionInset.top + self.sectionInset.bottom
            } else {    // Col left
                nowY = self.leftY
                nowX = self.sectionInset.left
                self.leftY = self.leftY + itemHeight + self.sectionInset.top + self.sectionInset.bottom
            }
    //        println("R:\(rightY) L:\(leftY)")
            attributes.frame = CGRectMake(nowX, nowY, self.itemWidth, itemHeight)
            self.layoutDic["\(indexPath.section)-\(indexPath.item)"] = CGRectMake(nowX,nowY,self.itemWidth,itemHeight)
//            println("S:(\(indexPath.section)-\(indexPath.item)) \(attributes.frame.size.width),\(attributes.frame.size.height)")
        }
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var layoutAttributes = NSMutableArray()
        dispatch_sync(self.lockQueue) {
            println("reset")
            
            let sectionCount = self.collectionView?.numberOfSections()
            var index = 0
            for var indexOfSection = 0; indexOfSection < sectionCount; indexOfSection++ {
                let itemInSectionCount = self.collectionView?.numberOfItemsInSection(indexOfSection)
                for var indexOfItemInSection = 0; indexOfItemInSection < itemInSectionCount; indexOfItemInSection++ {
                    var indexPath = NSIndexPath(forItem: indexOfItemInSection, inSection: indexOfSection)
                    //println("\(indexPath.section) : \(indexPath.item)")
                    let a = (self.layoutAttributesForItemAtIndexPath(indexPath, index: index++))
                    if(rect.intersects(a.frame)){
                        layoutAttributes.addObject(a)
//                        println("INTERSECT")
                    }
                    
                    println("A:\(indexPath.section)-\(indexPath.item)")
                }
            }
            println("reset END \(layoutAttributes.count)")
//            println("LOAD ATTR:\(layoutAttributes.count) in RECT:\(rect.origin.x) \(rect.origin.y) \(rect.size.width) \(rect.size.height)")
        }
        return layoutAttributes as [AnyObject]
    }
    
    
    
    
}