//
//  FromAvatarCollectionViewCell.swift
//  Gabb
//
//  Created by Evan Waters on 4/29/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class FromAvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    var text: NSAttributedString? {
        didSet {
            self.label.attributedText = self.text
        }
    }
}