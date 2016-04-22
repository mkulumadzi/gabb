//
//  GabbTextButton.swift
//  Gabb
//
//  Created by Evan Waters on 4/22/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class GabbTextButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3.0
    }
    
    override var enabled:Bool {
        didSet {
            super.enabled = enabled
            if (enabled) {
                self.alpha = 1.0
            } else {
                self.alpha = 0.8
            }
        }
    }

}
