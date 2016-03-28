//
//  FileService.swift
//  Gabb
//
//  Created by Evan Waters on 3/27/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit

class FileService {
    
    class func saveImageToDirectory(image: UIImage, fileName: String) -> Bool {
        let path = convertFileNameToNSURL(fileName)
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        let success = imageData.writeToURL(path, atomically: true)
        return success
    }
    
    class func savePNGToDirectory(image: UIImage, fileName: String) -> Bool {
        let path = convertFileNameToNSURL(fileName)
        let imageData = UIImagePNGRepresentation(image)!
        let success = imageData.writeToURL(path, atomically: true)
        return success
    }
    
    class func getImageFromDirectory(fileName: String) -> UIImage? {
        let path = convertFileNameToNSURL(fileName)
        var image:UIImage?
        if let data = NSData(contentsOfURL: path){
            image = UIImage(data: data)
        }
        return image
    }
    
    // MARK: - Private
    
    private class func convertFileNameToNSURL(url: String) -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        let fileName = convertUrlToFilename(url)
        let path = docURL.URLByAppendingPathComponent(fileName)
        return path
    }
    
    private class func convertUrlToFilename(url: String) -> String {
        let strArray = url.characters.split{$0 == "/"}.map(String.init)
        if let str = strArray.last {
            return str
        }
        else {
            return url
        }
    }
    
}