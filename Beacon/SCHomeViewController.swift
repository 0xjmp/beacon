//
//  SCHomeViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/4/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCHomeViewController: SCViewController {
    
    var tableView:SCHomeTableView
    var newZoneButton:SCNewZoneButton
    var zoneType:SCZoneType = SCZoneType.Invisible
    lazy var newZoneView:SCNewZoneView = { [unowned self] in
        var zoneView = SCNewZoneView(frame: CGRectZero)
        zoneView.layer.opacity = 0.0
        return zoneView
    }()
    
    var tableViewTag:Int = 10
    var zones:[SCZone] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        newZoneButton = SCNewZoneButton(frame: CGRectZero, zoneType:zoneType)
        newZoneButton.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        tableView = SCHomeTableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        newZoneButton.addTarget(self, action: "toggleZone", forControlEvents: UIControlEvents.TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SCBackgroundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let className = NSStringFromClass(SCTransitioningTableCell)
        tableView.registerClass(SCTransitioningTableCell.self, forCellReuseIdentifier: className)
    
        view.addSubview(tableView)
        view.addSubview(newZoneView)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let navigationBar = navigationController?.navigationBar {
            SCTheme.clearNavigation(navigationBar)
        }
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Actions  
    
    func deleteZone(indexPath:NSIndexPath!) {
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        let zone = zones.removeAtIndex(indexPath.row)
        SCZonesManager.delete(zone, completion: { (response, error) in
            // TODO: do we need to do anything?
        })
        
        tableView.endUpdates()
    }
    
    func createZone(name:String, radius:Int, latitude:Float, longitude:Float) {
        // TODO: start loading
        
        SCZonesManager.create(name, radius: radius, latitude: latitude, longitude: longitude, completion: { (zone, error) -> Void in
            if error == nil {
                self.zones.append(zone as! SCZone)
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        })
    }
    
    func openZone() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.newZoneButton.plusImageView.transform = CGAffineTransformMakeRotation(-0.8)
            self.newZoneButton.myTitleLabel.layer.opacity = 0.0
            self.newZoneView.layer.opacity = 1.0
            self.newZoneButton.closeLabel.layer.opacity = 1.0
        }, completion: { (finished) in
            if finished && !self.newZoneView.nameField.isFirstResponder() {
                self.newZoneView.nameField.becomeFirstResponder()
            }
        })
    }
    
    func closeZone() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.newZoneButton.plusImageView.transform = CGAffineTransformMakeRotation(0)
            
            self.newZoneView.layer.opacity = 0.0
            self.newZoneButton.closeLabel.layer.opacity = 0.0
            
            self.newZoneButton.myTitleLabel.layer.opacity = 1.0
        }, completion: { (finished) in
            if finished && self.newZoneView.nameField.isFirstResponder() {
                self.newZoneView.nameField.resignFirstResponder()
            }
        })
    }
    
    func toggleZone() {
        if newZoneButton.active == true {
            closeZone()
        } else {
            openZone()
        }
        
        newZoneButton.active = !newZoneButton.active
    }
}

extension SCHomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let className = NSStringFromClass(SCTransitioningTableCell)
        var cell:SCTransitioningTableCell? = tableView.dequeueReusableCellWithIdentifier(className, forIndexPath: indexPath) as? SCTransitioningTableCell
        if (cell == nil) {
            cell = SCTransitioningTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: className)
        }
        
        cell?.homeViewController = self
        cell?.indexPath = indexPath
        
        let zone = zones[indexPath.row]
        cell?.zone = zone
        
        cell?.myContentView!.tag = tableViewTag
        
        return cell!
    }
}

extension SCHomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.addSubview(newZoneButton)

        newZoneButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let views = ["zoneBtn" : newZoneButton]
        var vConstraints:[AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[zoneBtn]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views)
        let zoneConstraint = NSLayoutConstraint(item: newZoneButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        vConstraints.append(zoneConstraint)
        view.addConstraints(vConstraints)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SCTransitioningTableCell.cellHeight
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero

        cell.layoutMargins = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
        cell.separatorInset = UIEdgeInsetsZero
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if let transitionCell = cell as? SCTransitioningTableCell {
            cell.editingAccessoryView = transitionCell.deleteButton.deleteConfirmationButton
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let view = cell.contentView.viewWithTag(self.tableViewTag) {
            view.removeFromSuperview()
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteZone(indexPath)
        }
    }
    
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.editing == true {
                cell.setEditing(false, animated: true)
            }
        }
        
    }
}