//
//  SCHomeViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/4/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCHomeViewController: UIViewController {
    
    var tableView:UITableView!
    
    var tableViewTag:Int = 10
    
    var cellHeight:CGFloat = 65.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        let className = NSStringFromClass(UITableViewCell)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: className)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: SCTheme.logoImageView)
        
        if let navController = self.navigationController {
            SCTheme.clearNavigation(navController.navigationBar)
        }
        
        self.tableView.frame = self.view.bounds
    }
    
    func contentView(cell:UITableViewCell!, indexPath:NSIndexPath!) -> UIView {
        switch (indexPath.section) {
        case 0:
            let viewController = SCSocialIconsViewController()
            viewController.view.frame = cell.bounds
            return viewController.view
         
        default:
            return UIView()
        }
    }
    
}

extension SCHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let className = NSStringFromClass(UITableViewCell)
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(className, forIndexPath: indexPath) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: className)
        }
        
        let view = self.contentView(cell, indexPath: indexPath)
        view.tag = self.tableViewTag
        cell!.contentView.addSubview(view)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let view = cell.contentView.viewWithTag(self.tableViewTag) {
            view.removeFromSuperview()
        }
    }
}
