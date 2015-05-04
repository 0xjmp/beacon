//
//  SCHomeTableView.swift
//  Beacon
//
//  Created by Jake Peterson on 4/16/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit

class SCHomeTableView: UITableView {
    
    lazy var lineSeperator:CALayer = { [unowned self] in
        var layer = CALayer()
        layer.backgroundColor = UIColor.blackColor().CGColor
        return layer
    }()
    
    lazy var collectionViewLayout:UICollectionViewLayout = { [unowned self] in
        let spacing:CGFloat = 15.0
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        return layout
    }()
    
    var servicesCollectionView:SCServicesCollectionView!

    override init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame: frame, style: style)
        
        servicesCollectionView = SCServicesCollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        
        separatorInset = UIEdgeInsetsZero
        separatorColor = UIColor.blackColor()
        backgroundColor = UIColor.clearColor()
        backgroundView = nil
        opaque = true
        contentInset = UIEdgeInsetsZero
        tableFooterView = UIView(frame: CGRectZero)
        allowsMultipleSelectionDuringEditing = false
        bounces = true
        layer.addSublayer(lineSeperator)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        servicesCollectionView.frame = CGRectMake(0, 0, bounds.size.width, servicesCollectionView.bounds.size.height)
        
        lineSeperator.frame = CGRectMake(0, 0, bounds.size.width, 0.50)
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
    var zone:SCZone? {
        didSet {
            self.myContentView?.removeFromSuperview()
            
            self.myContentView = self.contentView(zone)
            self.contentView.addSubview(self.myContentView!)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentView(zone:SCZone!) -> UIView {
        var view = UIView(frame: CGRectMake(0, 0, self.bounds.size.width, SCTransitioningTableCell.cellHeight))
        view.backgroundColor = UIColor.clearColor()
        
        let margin:CGFloat = 20.0
        
        var deleteImage = UIImage(named: "xblack")!
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
        self.titleLabel.text = zone.name
        view.addSubview(self.titleLabel)
        
        frame = CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame), titleLabel.bounds.size.width, 17)
        self.subtitleLabel = UILabel(frame: frame)
        let gray:CGFloat = 220.0/255.0
        self.subtitleLabel.textColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1.0)
        self.subtitleLabel.font = SCTheme.primaryFont(15)
        // TODO: add location string to zone
        //        self.subtitleLabel.text = zone.address
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

extension SCTransitioningTableCell: SCDeleteCellDelegate {
    
    func executeDeletion(indexPath:NSIndexPath!) {
        if let homeController = self.homeViewController {
            homeViewController?.deleteZone(indexPath)
        }
    }
    
}