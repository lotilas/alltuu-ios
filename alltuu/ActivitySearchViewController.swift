//
//  ActivitySearchViewController.swift
//  alltuu
//
//  Created by MAC on 15/9/16.
//  Copyright (c) 2015年 Alltuu. All rights reserved.
//

import UIKit

class ActivitySearchViewController: AtViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.text = "浙江"
        }
    }
    
    @IBOutlet weak var searchResultView: ActivitySearchView! {
        didSet {
            searchResultView.dataSource = self
            searchResultView.delegate = self
        }
    }
    
    var currentPage = 1
    var pageCount = 12
    var marginLeft:CGFloat = 8
    var marginRight:CGFloat = 8
    var marginTop:CGFloat = 5
    var marginBottom:CGFloat = 0
    
    var activities = [[Activity]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultView.layer.backgroundColor = UIColor(colorString: "#F0F0F0").CGColor
        searchBar.becomeFirstResponder()
        self.searchResultView.initLoadMoreFootView( { () -> () in
            self.delay(0.5, closure: { () -> () in})
            self.delay(0.5, closure: { () -> () in
                self.currentPage++
                self.search()
            })
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationView!.setTitle("活动查找")
    }
    
    // tableView datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activities.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AtIdentifies.ActivitySearchCell.rawValue, forIndexPath: indexPath) as! ActivitySearchCell
        cell.activity = self.activities[indexPath.section][indexPath.item]
        return cell
    }
    
    // tableview delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.view.frame.width - marginLeft - marginRight) * 0.39 + marginTop + marginBottom
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.activities.removeAll()
        if searchBar.text != nil {
            currentPage = 1
            searchBar.resignFirstResponder()
            search()
        }
    }
    
    func search(){
        let keyword = searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        AtHttpClient().searchActivities(keyword, pageCount: pageCount, page: currentPage, returnHandler: { (error:Int, activities:Array<Activity>) in
            self.activities.append(activities)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if activities.count < self.pageCount {
                    self.searchResultView.didLoadAll()
                } else {
                    self.searchResultView.didLoadMore()
                }
                self.searchResultView.reloadData()
            }
        })
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let cell = sender as? ActivitySearchCell {
            if !cell.activity!.needPassword {
                return true
            }
        }
        return false
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? ActivitySearchCell {
            if let destCtrler = segue.destinationViewController as? ActivityPhotosViewController{
                destCtrler.activityId = cell.activity!.id
                destCtrler.activityTitle = cell.activity!.title
            }
        }
    }
}
