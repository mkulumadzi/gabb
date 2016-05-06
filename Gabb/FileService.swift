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
    
    class func getFullImageForURL(imageURL:String, completion: (result: UIImage?) -> Void) {
        if let image = self.getImageFromDirectory(imageURL) {
            let fullImage = image.af_imageScaledToSize(fullSize)
            completion(result: fullImage)
        }
        else {
            RestService.downloadImage(imageURL, completion: {(image) -> Void in
                if let image = image {
                    self.saveImageToDirectory(image, imageURL: imageURL)
                    let fullImage = image.af_imageScaledToSize(fullSize)
                    completion(result: fullImage)
                }
            })
        }
    }
    
    class func getThumbnailImageForURL(imageURL:String, completion: (result: UIImage?) -> Void) {
        if let image = self.getImageFromDirectory(imageURL) {
            let thumbImage = image.af_imageScaledToSize(thumbnailSize)
            completion(result: thumbImage)
        }
        else {
            RestService.downloadImage(imageURL, completion: {(image) -> Void in
                if let image = image {
                    self.saveImageToDirectory(image, imageURL: imageURL)
                    let thumbImage = image.af_imageScaledToSize(thumbnailSize)
                    completion(result: thumbImage)
                }
            })
        }
    }
    
    class func getLargeThumbnailImageForURL(imageURL:String, completion: (result: UIImage?) -> Void) {
        if let image = self.getImageFromDirectory(imageURL) {
            let thumbImage = image.af_imageScaledToSize(largeThumbnailSize)
            completion(result: thumbImage)
        }
        else {
            RestService.downloadImage(imageURL, completion: {(image) -> Void in
                if let image = image {
                    self.saveImageToDirectory(image, imageURL: imageURL)
                    let thumbImage = image.af_imageScaledToSize(largeThumbnailSize)
                    completion(result: thumbImage)
                }
            })
        }
    }
    
    class func saveImageToDirectory(image: UIImage, imageURL: String) -> Bool {
        let path = convertFileNameToNSURL(imageURL)
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        let success = imageData.writeToURL(path, atomically: true)
        return success
    }
    
    class func savePNGToDirectory(image: UIImage, imageURL: String) -> Bool {
        let path = convertFileNameToNSURL(imageURL)
        let imageData = UIImagePNGRepresentation(image)!
        let success = imageData.writeToURL(path, atomically: true)
        return success
    }
    
    class func getImageFromDirectory(imageURL: String) -> UIImage? {
        let path = convertFileNameToNSURL(imageURL)
        var image:UIImage?
        if let data = NSData(contentsOfURL: path){
            image = UIImage(data: data)
        }
        return image
    }
    
    // MARK: - Private
    
    private class func convertFileNameToNSURL(imageUrl: String) -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        let fileName = imageUrl.toHashWithExtension()
        let path = docURL.URLByAppendingPathComponent(fileName)
        return path
    }
    
}