//
//  SCHomeViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/4/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

class SCHomeViewController: SCViewController {
    
    var zoneType:SCZoneType = SCZoneType.Invisible
    var newZoneButton:SCNewZoneButton
    
    lazy var newZoneView:SCNewZoneView = { [unowned self] in
        var zoneView = SCNewZoneView(frame: CGRectZero)
        zoneView.layer.opacity = 0.0
        return zoneView
    }()
    
    lazy var defaultLayout:UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0)
        return layout
    }()
    
    lazy var servicesCollectionView:SCIdentitiesCollectionView = {
        let collectionView = SCIdentitiesCollectionView(frame: CGRectZero, collectionViewLayout: self.defaultLayout)
        return collectionView
    }()
    
    var tableView:SCZonesTableView
    
    var tableViewTag:Int = 10
    var zones:[SCZone] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        newZoneButton = SCNewZoneButton(frame: CGRectZero, zoneType:zoneType)
        newZoneButton.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        tableView = SCZonesTableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        servicesCollectionView.viewControllerDelegate = self
        
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
    
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        servicesCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        newZoneButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        newZoneView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(tableView)
        view.addSubview(servicesCollectionView)
        view.addSubview(newZoneButton)
        view.addSubview(newZoneView)
        
        let servicesWidthConstraint = NSLayoutConstraint(
            item: servicesCollectionView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1,
            constant: 0
        )
        let newZoneWidthConstant = NSLayoutConstraint(
            item: newZoneButton,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1,
            constant: 0
        )
        let newZoneViewWidthConstraint = NSLayoutConstraint(
            item: newZoneView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1,
            constant: 0
        )
        let newZoneViewYConstraint = NSLayoutConstraint(
            item: newZoneView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: tableView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0
        )
        let tableViewWidthConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1,
            constant: 0
        )
        let views = ["servicesView" : servicesCollectionView, "newZoneView" : newZoneButton, "tableView" : tableView]
        let vConstraints:NSArray = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-85-[servicesView(==70)][newZoneView(==50)][tableView]|",
            options: NSLayoutFormatOptions.AlignAllLeading,
            metrics: nil,
            views: views
        )
        
        view.addConstraints(vConstraints.arrayByAddingObjectsFromArray(
            [servicesWidthConstraint, newZoneWidthConstant, newZoneViewWidthConstraint, newZoneViewYConstraint, tableViewWidthConstraint]
        ))
    }
    
    override func viewWillAppear(animated: Bool) {
        if let navigationBar = navigationController?.navigationBar {
            SCTheme.clearNavigation(navigationBar)
        }
    }
    
    // MARK: - Actions
    
    func toggleZone() {
        if newZoneButton.active == false {
            let viewController = SCNewZoneViewController(nibName: nil, bundle: nil)
            presentViewController(viewController, animated: true, completion: nil)
        }
        
        newZoneButton.toggleZone { (finished) -> Void in
            if finished {
                if self.newZoneView.nameField.isFirstResponder() == false {
                    self.newZoneView.nameField.becomeFirstResponder()
                } else {
                    self.newZoneView.nameField.resignFirstResponder()
                }
            }
        }
    }
    
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
}

extension SCHomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let className = NSStringFromClass(SCTransitioningTableCell)
        let cell:SCTransitioningTableCell = tableView.dequeueReusableCellWithIdentifier(className, forIndexPath: indexPath) as! SCTransitioningTableCell
        
        cell.homeViewController = self
        cell.indexPath = indexPath
        
        let zone = zones[indexPath.row]
        cell.zone = zone
        
        cell.myContentView!.tag = tableViewTag
        
        return cell
    }
}

extension SCHomeViewController: UITableViewDelegate {
    
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
