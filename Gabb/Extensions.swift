//
//  Extensions.swift
//  Gabb
//
//  Created by Evan Waters on 3/25/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func gabbPrimaryColor() -> UIColor {
        return UIColor.colorWithHexString("#f55d4b")
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
    

    
//    + (UIColor *) colorWithHexString: (NSString *) hexString {
//    /*borrowed from http://stackoverflow.com/a/7180905
//    I've got a solution that is 100% compatible with the hex format strings used by Android, which I found very helpful when doing cross-platform mobile development. It lets me use one color palate for both platforms. Feel free to reuse without attribution, or under the Apache license if you prefer.
//    by - http://stackoverflow.com/users/590840/micah-hainline
//    */
//    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
//    CGFloat alpha, red, blue, green;
//    switch ([colorString length]) {
//    case 3: // #RGB
//    alpha = 1.0f;
//    red   = [self colorComponentFrom: colorString start: 0 length: 1];
//    green = [self colorComponentFrom: colorString start: 1 length: 1];
//    blue  = [self colorComponentFrom: colorString start: 2 length: 1];
//    break;
//    case 4: // #ARGB
//    alpha = [self colorComponentFrom: colorString start: 0 length: 1];
//    red   = [self colorComponentFrom: colorString start: 1 length: 1];
//    green = [self colorComponentFrom: colorString start: 2 length: 1];
//    blue  = [self colorComponentFrom: colorString start: 3 length: 1];
//    break;
//    case 6: // #RRGGBB
//    alpha = 1.0f;
//    red   = [self colorComponentFrom: colorString start: 0 length: 2];
//    green = [self colorComponentFrom: colorString start: 2 length: 2];
//    blue  = [self colorComponentFrom: colorString start: 4 length: 2];
//    break;
//    case 8: // #AARRGGBB
//    alpha = [self colorComponentFrom: colorString start: 0 length: 2];
//    red   = [self colorComponentFrom: colorString start: 2 length: 2];
//    green = [self colorComponentFrom: colorString start: 4 length: 2];
//    blue  = [self colorComponentFrom: colorString start: 6 length: 2];
//    break;
//    default:
//    [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
//    break;
//    }
//    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
//    }
    
}
