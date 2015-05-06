//
//  SCIdentitiesCollectionView.swift
//  Beacon
//
//  Created by Jake Peterson on 4/16/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit

class SCIdentitiesCollectionView: UICollectionView {
    
    var viewControllerDelegate:SCViewControllerProtocol? {
        didSet {
            for identityButton in identities {
                identityButton.viewControllerDelegate = viewControllerDelegate
            }
        }
    }
    
    var identities:[SCIdentityButton] = [] {
        didSet {
            reloadData()
        }
    }
    
    var className:String {
        get {
            return NSStringFromClass(UICollectionViewCell.self)
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        for type in SCIdentityType.allValues {
            let button = SCIdentityButton(on: false, identityType: type)
            identities.append(button)
        }
        
        dataSource = self
        backgroundColor = UIColor.clearColor()
        
        self.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: className)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, 70)
    }
}

extension SCIdentitiesCollectionView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return identities.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(className, forIndexPath: indexPath) as! UICollectionViewCell
        
        let tag = 73649
        var button = cell.contentView.viewWithTag(tag)
        
        if button == nil {
            button = identities.reverse()[indexPath.row]
            cell.contentView.addSubview(button!)
            
            button!.setTranslatesAutoresizingMaskIntoConstraints(false)
            cell.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            let views:[NSObject : AnyObject] = ["button" : button!]
            let hConstraints:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: views)
            let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: views)
            cell.contentView.addConstraints(hConstraints.arrayByAddingObjectsFromArray(vConstraints))
        }
        
        button?.tag = tag
        
        return cell
    }
}
