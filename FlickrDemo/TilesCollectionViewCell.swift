//
//  TilesCollectionViewCell.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import UIKit

class TilesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tileView: UIView!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewRightConstraint: NSLayoutConstraint!
    
    
    
}
