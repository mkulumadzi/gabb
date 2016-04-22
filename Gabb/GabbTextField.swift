//
//  GabbTextField.swift
//  Gabb
//
//  Created by Evan Waters on 4/22/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit

class GabbTextField: UITextField {
    
    var bottomBorderView:UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorder()
    }
    
    private func addBottomBorder() {
        if self.bottomBorderView == nil {
            let y = self.frame.height - 1
            let width = self.frame.width
            let frame = CGRectMake(0, y, width, 1)
            bottomBorderView = UIView(frame: frame)
            bottomBorderView.backgroundColor = UIColor.gabbLightGreyColor()
            self.addSubview(bottomBorderView)
        }
    }



}
