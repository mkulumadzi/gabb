//
//  Colors.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /*
     Adapted solution from http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    */
    class func readableColorForBackground(backgroundColor: UIColor) -> UIColor {
        let count = CGColorGetNumberOfComponents(backgroundColor.CGColor)
        let componentColors = CGColorGetComponents(backgroundColor.CGColor)
        
        var darknessScore:CGFloat = 0.0
        if (count == 2) {
            let component1 = componentColors[0]*255 * 299
            let component2 = componentColors[0]*255 * 587
            let component3 = componentColors[0]*255 * 114
            darknessScore = (component1 + component2 + component3) / 1000
        }
        else if (count == 4) {
            let component1 = componentColors[0]*255 * 299
            let component2 = componentColors[1]*255 * 587
            let component3 = componentColors[2]*255 * 114
            darknessScore = (component1 + component2 + component3) / 1000
        }
        
        if (darknessScore >= 125) {
            return UIColor.gabbRedColor()
        }
        else {
            return UIColor.whiteColor()
        }
    }
    
    class func gabbRedColor() -> UIColor {
        return UIColor.colorWithHexString("#f55d4b")
    }
    
    class func gabbDarkRedColor() -> UIColor {
        return UIColor.colorWithHexString("#AF4236")
    }
    
    class func gabbBlackColor() -> UIColor {
        return UIColor.colorWithHexString("#0B0B0B")
    }
    
    class func gabbDarkGreyColor() -> UIColor {
        return UIColor.colorWithHexString("#3E4F4F")
    }
    
    class func gabbLightGreyColor() -> UIColor {
        return UIColor.colorWithHexString("#95A5A6")
    }
    
    private class func colorComponentFrom(string: String, start: Int, length: Int) -> CGFloat {
        let index1 = string.startIndex.advancedBy(start)
        let substring1 = string.substringFromIndex(index1)
        
        let index2 = substring1.startIndex.advancedBy(length)
        let substring2 = substring1.substringToIndex(index2)
        
        let fullHex = length == 2 ? substring2 : substring2 + substring2
        
        var hexString:CUnsignedInt = 0;
        NSScanner.init(string: fullHex).scanHexInt(&hexString)
        
        return CGFloat(hexString) / 255.0
    }
    
    private class func colorWithHexString(hexString: String) -> UIColor {
        let colorString = hexString.stringByReplacingOccurrencesOfString("#", withString: "")
        var alpha:CGFloat!
        var red:CGFloat!
        var blue:CGFloat!
        var green:CGFloat!
        
        switch (colorString.characters.count) {
        case 3: //#RGB
            alpha = 1.0
            red = UIColor.colorComponentFrom(colorString, start: 0, length: 1)
            green = UIColor.colorComponentFrom(colorString, start: 1, length: 1)
            blue = UIColor.colorComponentFrom(colorString, start: 2, length: 1)
            break
        case 4: //#ARGB
            alpha = UIColor.colorComponentFrom(colorString, start: 0, length: 1)
            red = UIColor.colorComponentFrom(colorString, start: 1, length: 1)
            green = UIColor.colorComponentFrom(colorString, start: 2, length: 1)
            blue = UIColor.colorComponentFrom(colorString, start: 3, length: 1)
            break
        case 6: // #RRGGBB
            alpha = 1.0
            red = UIColor.colorComponentFrom(colorString, start: 0, length: 2)
            green = UIColor.colorComponentFrom(colorString, start: 2, length: 2)
            blue = UIColor.colorComponentFrom(colorString, start: 2, length: 2)
            break
        case 8: // #RRGGBB
            alpha = UIColor.colorComponentFrom(colorString, start: 0, length: 2)
            red = UIColor.colorComponentFrom(colorString, start: 2, length: 2)
            green = UIColor.colorComponentFrom(colorString, start: 4, length: 2)
            blue = UIColor.colorComponentFrom(colorString, start: 4, length: 1)
            break
        default:
            NSException.raise("Invalid color value", format: "Color value \(hexString) is invalid. It should be a hex value of the form #RGB, #ARGB, #RRGGBB, #AARRGGBB", arguments:getVaList(["nil"]))
            break
        }
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)

    }
    
}
