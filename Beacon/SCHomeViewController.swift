//
//  SCHomeViewController.swift
//  Beacon
//
//  Created by Jake Peterson on 10/4/14.
//  Copyright (c) 2014 Jake Peterson. All rights reserved.
//

import UIKit

protocol SCDeleteCellDelegate {
    func executeDeletion(indexPath:NSIndexPath!)
}

class SCDeleteCellButton:UIButton {
    var cell:UITableViewCell!
    var indexPath:NSIndexPath?
    var delegate:SCDeleteCellDelegate?
    
    var deleteConfirmationButton:UIButton!
    
    init(cell:UITableViewCell!) {
        self.cell = cell
        
        super.init(frame: CGRectZero)
        
        self.addTarget(self, action: "stageForDeletion", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.deleteConfirmationButton = UIButton(frame: CGRectMake(0, 0, 75, cell.bounds.size.height))
        self.deleteConfirmationButton.setTitle("Delete", forState: UIControlState.Normal)
        self.deleteConfirmationButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.deleteConfirmationButton.backgroundColor = UIColor.redColor()
        self.deleteConfirmationButton.addTarget(self, action: "confirmDelete", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    func confirmDelete() {
        if let delegate = self.delegate {
            delegate.executeDeletion(self.indexPath)
        }
    }
    
    func stageForDeletion() {
        self.cell.setEditing(!self.cell.editing, animated: true)
    }
}

class SCInvisibleAreaButton:UIButton {
    var plusImageView:UIImageView!
    var myTitleLabel:UILabel!
    var closeLabel:UILabel!
    var defaultTitleText = "New Invisible Area"
    var active:Bool!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        let image = UIImage(named: "pluswhite")
        self.plusImageView = UIImageView(image: image)
        self.plusImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        self.plusImageView.userInteractionEnabled = false
        self.plusImageView.contentMode = UIViewContentMode.Center
        self.addSubview(self.plusImageView)
        
        self.myTitleLabel = UILabel()
        self.myTitleLabel.font = SCTheme.primaryFont(27)
        self.myTitleLabel.textColor = SCTheme.primaryTextColor
        self.myTitleLabel.text = self.defaultTitleText
        self.myTitleLabel.userInteractionEnabled = false
        self.addSubview(self.myTitleLabel)
        
        self.closeLabel = UILabel()
        self.closeLabel.font = SCTheme.primaryFont(27)
        self.closeLabel.textColor = SCTheme.primaryTextColor
        self.closeLabel.text = "Cancel"
        self.closeLabel.userInteractionEnabled = false
        self.closeLabel.layer.opacity = 0.0
        self.addSubview(self.closeLabel)
        
        self.active = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin:CGFloat = 16
        
        self.plusImageView.frame = CGRectMake(margin, 0, self.plusImageView.bounds.size.width, self.plusImageView.bounds.size.height)
        var center = self.plusImageView.center
        center.y = self.bounds.size.height / 2
        self.plusImageView.center = center
        
        var frame = self.myTitleLabel.frame
        frame.origin.x = CGRectGetMaxX(self.plusImageView.frame) + 10
        frame.size.width = self.bounds.size.width - CGRectGetMinX(frame)
        frame.size.height = self.plusImageView.bounds.size.height
        self.myTitleLabel.frame = frame
        center = self.myTitleLabel.center
        center.y = self.bounds.size.height / 2
        self.myTitleLabel.center = center
        
        self.closeLabel.frame = self.myTitleLabel.frame
    }
}

class SCTransitioningTableCell:UITableViewCell {
    
    var deleteButton:SCDeleteCellButton!
    var titleLabel:UILabel!
    var subtitleLabel:UILabel!
    var indexPath:NSIndexPath?
    var homeViewController:SCHomeViewController?
    class var cellHeight:CGFloat {
        get {
            return 63.0
        }
    }
    var myContentView:UIView?
    var invisibleArea:SCInvisibleArea? {
        didSet {
            self.myContentView?.removeFromSuperview()
            
            self.myContentView = self.contentView(invisibleArea)
            self.contentView.addSubview(self.myContentView!)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentView(invisibleArea:SCInvisibleArea!) -> UIView {
        var view = UIView(frame: CGRectMake(0, 0, self.bounds.size.width, SCTransitioningTableCell.cellHeight))
        view.backgroundColor = UIColor.clearColor()
        
        let margin:CGFloat = 20.0
        
        var deleteImage = UIImage(named: "xblack")
        let y:CGFloat = view.bounds.size.height / 2 - (deleteImage.size.height / 2)
        self.deleteButton = SCDeleteCellButton(cell: self)
        self.deleteButton.frame = CGRectMake(margin, y, deleteImage.size.width, deleteImage.size.height)
        self.deleteButton.indexPath = self.indexPath
        self.deleteButton.delegate = self
        self.deleteButton.setImage(deleteImage, forState: UIControlState.Normal)
        view.addSubview(self.deleteButton)
        
        var x = CGRectGetMaxX(deleteButton.frame) + 15
        var frame = CGRectMake(x, 7.5, view.bounds.size.width - (x + margin), 30)
        self.titleLabel = UILabel(frame: frame)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.font = SCTheme.primaryFont(25)
        self.titleLabel.text = invisibleArea.name
        view.addSubview(self.titleLabel)
        
        frame = CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.bounds.size.width, 17)
        self.subtitleLabel = UILabel(frame: frame)
        let gray:CGFloat = 220.0/255.0
        self.subtitleLabel.textColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.subtitleLabel.font = SCTheme.primaryFont(15)
        self.subtitleLabel.text = invisibleArea.location
        view.addSubview(self.subtitleLabel)
        
        return view
    }
    
    override func willTransitionToState(state: UITableViewCellStateMask) {
        super.willTransitionToState(state)
        
        if let view = self.myContentView {
            var frame = view.frame
            frame.origin.x = self.editing ? 0 : -75
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                view.frame = frame
            })
        }
    }
}

extension SCTransitioningTableCell: SCDeleteCellDelegate {
    
    func executeDeletion(indexPath:NSIndexPath!) {
        if let homeController = self.homeViewController {
            homeViewController?.deleteInvisibleArea(indexPath)
        }
    }
    
}

class SCHomeViewController: SCBeaconViewController {
    
    var tableView:UITableView!
    var socialToolbar:SCSocialIconsToolbar!
    var invisibleAreaButton:SCInvisibleAreaButton!
    var tableViewTag:Int = 10
    var invisibleAreas:NSArray?
    var tableViewSeparator:CALayer!
    var newInvisibleAreaView:SCNewInvisibleAreaView!
    
    override func loadView() {
        super.loadView()
    
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("background", ofType: "jpg")!)
        let imageView = UIImageView(image: image)
        imageView.userInteractionEnabled = true
        self.view = imageView
        
        self.view = SCBackgroundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.dataSource = self
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.separatorColor = UIColor.blackColor()
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = nil
        self.tableView.opaque = true
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.view.addSubview(self.tableView)
        
        self.tableViewSeparator = CALayer()
        self.tableViewSeparator.backgroundColor = UIColor.blackColor().CGColor
        self.tableView.layer.addSublayer(self.tableViewSeparator)
        
        let className = NSStringFromClass(SCTransitioningTableCell)
        self.tableView.registerClass(SCTransitioningTableCell.self, forCellReuseIdentifier: className)
        
        self.socialToolbar = SCSocialIconsToolbar(frame: CGRectMake(0, 0, 0, 70))
        self.socialToolbar.delegate = self
        self.view.addSubview(self.socialToolbar)
        
        self.invisibleAreaButton = SCInvisibleAreaButton(frame: CGRectZero)
        self.invisibleAreaButton.addTarget(self, action: "toggleInvisibleArea", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.invisibleAreaButton)
        
        self.newInvisibleAreaView = SCNewInvisibleAreaView(frame: CGRectZero)
        self.newInvisibleAreaView.actionDelegate = self
        
        self.getInvisibleZones()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: SCTheme.logoImageView)
        
        if let navigationBar = self.navigationController?.navigationBar {
            SCTheme.clearNavigation(navigationBar)
            
            self.socialToolbar.frame = CGRectMake(0, CGRectGetMaxY(navigationBar.frame), self.view.bounds.size.width, self.socialToolbar.bounds.size.height)
        }
        
        self.invisibleAreaButton.frame = CGRectMake(0, CGRectGetMaxY(self.socialToolbar.frame) + 10, self.view.bounds.size.width, 70)
        
        var frame = CGRectZero
        frame.origin.y = CGRectGetMaxY(self.invisibleAreaButton.frame)
        frame.size.width = self.view.bounds.size.width
        frame.size.height = self.view.bounds.size.height - CGRectGetMinY(frame)
        self.tableView.frame = frame
        
        self.tableViewSeparator.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 0.50)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.contentInset = UIEdgeInsetsZero
    }
    
    // MARK: - Actions
    
    func getInvisibleZones() {
        if let user = SCUser.currentUser {
            self.invisibleAreaButton.myTitleLabel.text = "Loading..."
            self.invisibleAreaButton.plusImageView.hidden = true
            self.invisibleAreaButton.userInteractionEnabled = false
            
            SCUser.getUserProfile(user.objectId, completionHandler: { (responseObject, error) -> Void in
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
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        if let mutableAreas:NSMutableArray = self.invisibleAreas?.mutableCopy() as? NSMutableArray {
            mutableAreas.removeObjectAtIndex(indexPath.row)
            self.invisibleAreas = mutableAreas as NSArray
        }
        self.tableView.endUpdates()
        
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
    
    func create(invisibleArea:SCInvisibleArea!) {
        self.closeInvisibleArea()
        
        if let mutableAreas: NSMutableArray = self.invisibleAreas?.mutableCopy() as? NSMutableArray {
            mutableAreas.addObject(invisibleArea)
            self.invisibleAreas = mutableAreas
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        SCUser.create(invisibleArea, completionHandler: { (responseObject, error) -> Void in
            if error == nil {
                if self.invisibleAreas?.count != SCUser.currentUser?.invisibleAreas?.count {
                    self.invisibleAreas = SCUser.currentUser?.invisibleAreas
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            }
        })
    }
    
}

extension SCHomeViewController {
    
    func openInvisibleArea() {
        if let superview = self.newInvisibleAreaView.superview {
            self.newInvisibleAreaView.removeFromSuperview()
        }
        
        self.newInvisibleAreaView.layer.opacity = 0.0
        self.newInvisibleAreaView.frame = self.tableView.frame
        self.view.addSubview(self.newInvisibleAreaView)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.invisibleAreaButton.plusImageView.transform = CGAffineTransformMakeRotation(-0.8)
            self.newInvisibleAreaView.layer.opacity = 1.0
            self.invisibleAreaButton.myTitleLabel.layer.opacity = 0.0
            self.invisibleAreaButton.closeLabel.layer.opacity = 1.0
        })
        
    }
    
    func closeInvisibleArea() {
        if self.newInvisibleAreaView.superview == nil {
            return
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.invisibleAreaButton.plusImageView.transform = CGAffineTransformMakeRotation(0)
            self.newInvisibleAreaView.layer.opacity = 0.0
            self.invisibleAreaButton.myTitleLabel.layer.opacity = 1.0
            self.invisibleAreaButton.closeLabel.layer.opacity = 0.0
        }, completion:{ (success) -> Void in
            self.newInvisibleAreaView.removeFromSuperview()
        })
    }
    
    func toggleInvisibleArea() {
        if self.invisibleAreaButton.active == true {
            self.closeInvisibleArea()
        } else {
            self.openInvisibleArea()
        }
        self.invisibleAreaButton.active = !self.invisibleAreaButton.active
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
        return SCTransitioningTableCell.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let className = NSStringFromClass(SCTransitioningTableCell)
        var cell:SCTransitioningTableCell? = tableView.dequeueReusableCellWithIdentifier(className, forIndexPath: indexPath) as? SCTransitioningTableCell
        if (cell == nil) {
            cell = SCTransitioningTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: className)
        }
        
        cell?.homeViewController = self
        cell?.indexPath = indexPath
        
        var invisibleArea:SCInvisibleArea? = self.invisibleAreas?.objectAtIndex(indexPath.row) as? SCInvisibleArea
        cell?.invisibleArea = invisibleArea
        
        cell?.myContentView!.tag = self.tableViewTag
        
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: SCTransitioningTableCell!, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero

        cell.layoutMargins = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
        cell.separatorInset = UIEdgeInsetsZero
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.editingAccessoryView = cell.deleteButton.deleteConfirmationButton
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let view = cell.contentView.viewWithTag(self.tableViewTag) {
            view.removeFromSuperview()
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteInvisibleArea(indexPath)
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

extension SCHomeViewController: SCNewInvisibleAreaDelegate {
    
    func didCreateNew(invisibleArea:SCInvisibleArea!) {
        self.create(invisibleArea)
    }
    
}
