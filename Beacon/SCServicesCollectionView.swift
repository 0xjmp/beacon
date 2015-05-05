//
//  SCServicesCollectionView.swift
//  Beacon
//
//  Created by Jake Peterson on 4/16/15.
//  Copyright (c) 2015 Jake Peterson. All rights reserved.
//

import UIKit

class SCServicesCollectionView: UICollectionView {
    
    var services:[SCServiceButton] = [] {
        didSet {
            reloadData()
        }
    }
    
    var className:String {
        get {
            return NSStringFromClass(UICollectionViewCell.self)
        }
    }
    
    lazy var addButton:SCServiceButton = { [unowned self] in
        let image = UIImage(named: "addbutton")
        let clickedImage = UIImage(named: "addbuttonclicked")
        return SCServiceButton(on: false, defaultImage: image!, clickedImage: clickedImage!)
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        services.append(addButton)
        
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

extension SCServicesCollectionView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(className, forIndexPath: indexPath) as! UICollectionViewCell
        
        let tag = 73649
        var button = cell.contentView.viewWithTag(tag)
        
        if button == nil {
            button = services.reverse()[indexPath.row]
            cell.contentView.addSubview(button!)
        }
        
        button!.tag = tag
        
        return cell
    }
}
