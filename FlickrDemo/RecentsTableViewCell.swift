//
//  RecentsTableViewCell.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import UIKit

class RecentsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var photo: UIImageView?
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
