//
//  DateAndTime.swift
//  Gabb
//
//  Created by Evan Waters on 4/8/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension CMTime {
    
    func toString() -> String {
        var timeString:String!
        let interval = Int(CMTimeGetSeconds(self))
        let seconds = interval % 60
        let minutes = (interval / 60 ) % 60
        let hours = (interval / 3600)
        
        if (hours > 0) {
            timeString = String(format:"%d:%02d:%02d", hours, minutes, seconds)
        }
        else {
            timeString = String(format:"%02d:%02d", minutes, seconds)
        }
        
        return timeString
    }
    
}

extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateStringFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}