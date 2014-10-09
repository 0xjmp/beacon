//
//  SCHomeViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/4/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCInvisibleZoneButton:UIButton {
    var plusImageView:UIImageView {
        get {
            let image = UIImage(named: "plusblack")
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            imageView.userInteractionEnabled = false
            return imageView
        }
    }
    var myTitleLabel:UILabel {
        get {
            var label = UILabel()
            label.font = SCTheme.primaryFont(17)
            label.textColor = SCTheme.primaryTextColor
            label.text = self.defaultTitleText
            label.userInteractionEnabled = false
            return label
        }
    }
    var defaultTitleText = "New Invisible Area"
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.addSubview(self.plusImageView)
        self.addSubview(self.myTitleLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let margin:CGFloat = 10
        
        var frame = self.plusImageView.frame
        frame.origin.x = margin
        self.plusImageView.frame = frame
        
        frame = self.myTitleLabel.frame
        frame.origin.x = CGRectGetMaxX(self.plusImageView.frame) + margin
        frame.size.width = self.bounds.size.width - CGRectGetMinX(frame)
        frame.size.height = self.plusImageView.bounds.size.height
        self.myTitleLabel.frame = frame
    }
}

class SCHomeViewController: SCBeaconViewController {
    
    var tableView:UITableView!
    var socialToolbar:UIToolbar!
    var invisibleAreaButton:SCInvisibleZoneButton!
    var tableViewTag:Int = 10
    var cellHeight:CGFloat = 65.0
    var invisibleAreas:NSArray?
    
    override func loadView() {
        super.loadView()
    
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("background", ofType: "jpg")!)
        let imageView = UIImageView(image: image)
        imageView.userInteractionEnabled = true
        self.view = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.tableView.dataSource = self
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.separatorColor = UIColor.darkGrayColor()
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        let className = NSStringFromClass(UITableViewCell)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: className)
        
        var socialIconsController = SCSocialIconsViewController()
        socialIconsController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, socialIconsController.view.bounds.size.height)
        self.socialToolbar = SCTheme.socialToolBar(socialIconsController)
        self.socialToolbar.delegate = self
        self.view.addSubview(self.socialToolbar)
        
        self.invisibleAreaButton = SCInvisibleZoneButton(frame: CGRectZero)
        self.view.addSubview(self.invisibleAreaButton)
        
        self.getInvisibleZones()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: SCTheme.logoImageView)
        
        if let navigationBar = self.navigationController?.navigationBar {
            self.socialToolbar.frame = CGRectMake(0, CGRectGetMaxY(navigationBar.frame), self.view.bounds.size.width, self.socialToolbar.bounds.size.height)
        }
        
        self.invisibleAreaButton.frame = CGRectMake(0, CGRectGetMaxY(self.socialToolbar.frame), self.view.bounds.size.width, self.invisibleAreaButton.bounds.size.height)
        
        var frame = CGRectZero
        frame.origin.y = CGRectGetMaxY(self.invisibleAreaButton.frame)
        frame.size.width = self.view.bounds.size.width
        frame.size.height = self.view.bounds.size.height - CGRectGetMinY(frame)
        self.tableView.frame = frame
    }
    
    // MARK: - Actions
    
    func getInvisibleZones() {
        if let user = SCUser.currentUser {
            self.invisibleAreaButton.myTitleLabel.text = "Loading..."
            self.invisibleAreaButton.plusImageView.hidden = true
            self.invisibleAreaButton.userInteractionEnabled = false
            
            SCUser.getUserProfile(user.id, completionHandler: { (responseObject, error) -> Void in
                if error == nil {
                    self.invisibleAreas = SCUser.currentUser?.invisibleAreas
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                self.invisibleAreaButton.myTitleLabel.text = self.invisibleAreaButton.defaultTitleText
                self.invisibleAreaButton.plusImageView.hidden = false
                self.invisibleAreaButton.userInteractionEnabled = true
            })
        }
    }
    
    func deleteInvisibleArea(indexPath:NSIndexPath!) {
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        if let user = SCUser.currentUser {
            if let invisibleArea = self.invisibleAreas?.objectAtIndex(indexPath.row) as? SCInvisibleArea {
                SCUser.delete(invisibleArea, completionHandler: { (responseObject, error) -> Void in
                    if let user = SCUser.currentUser {
                        if let areas = self.invisibleAreas? {
                            self.invisibleAreas = areas
                            
                            if areas.count != user.invisibleAreas?.count {
                                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                            }
                        }
                    }
                })
            }
        }
    }
    
}

extension SCHomeViewController: UIToolbarDelegate {
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
}

extension SCHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.invisibleAreas?.count {
            return count
        }
        
        return 0
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
        
        if let invisibleArea = self.invisibleAreas?.objectAtIndex(indexPath.row) as? SCInvisibleArea {
            cell!.textLabel?.text = invisibleArea.name
            cell!.detailTextLabel?.text = invisibleArea.location
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.separatorInset = UIEdgeInsetsZero
        
        cell.textLabel?.font = SCTheme.primaryFont(14.0)
        cell.textLabel?.textColor = SCTheme.primaryTextColor
        cell.textLabel?.numberOfLines = 0
        
        cell.detailTextLabel?.font = SCTheme.primaryFont(12.0)
        cell.detailTextLabel?.textColor = SCTheme.primaryTextColor
        cell.detailTextLabel?.numberOfLines = 0
        
        // Setup the close button
        let margin:CGFloat = 10.0
        let image = UIImage(named: "xblack")
        var button = UIButton()
        button.tag = self.tableViewTag
        button.setImage(image, forState: UIControlState.Normal)
        button.frame = CGRectMake(margin, margin, image.size.width, image.size.height)
        button.addTarget(self, action: "stageForDeletion", forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(button)
        
        // Adjust the cell labels to the close button
        var textLabelFrame = cell.textLabel?.frame
        textLabelFrame?.origin.x = CGRectGetMaxX(button.frame) + margin
        cell.textLabel?.frame = textLabelFrame!
        
        var detailLabelFrame = cell.detailTextLabel?.frame
        detailLabelFrame?.origin.x = textLabelFrame!.origin.x
        cell.detailTextLabel?.frame = detailLabelFrame!
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let view = cell.contentView.viewWithTag(self.tableViewTag) {
            view.removeFromSuperview()
        }
        
        cell.textLabel!.text = ""
        cell.detailTextLabel!.text = ""
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "Delete"
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        self.deleteInvisibleArea(indexPath)
        return [NSObject()] // TODO: figure what to return here
    }
}
