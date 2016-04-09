//
//  PodcastCollectionViewCell.swift
//  Gabb
//
//  Created by Evan Waters on 3/26/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class PodcastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var podcast: NSMutableDictionary!
    
    override func layoutSubviews() {
        guard let titleLabel = titleLabel else {
            return
        }
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(15.0)
        titleLabel.backgroundColor = UIColor.gabbBlackColor()
        titleLabel.alpha = 0.8
        super.layoutSubviews()
    }
    
}