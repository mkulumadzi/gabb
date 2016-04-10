//
//  ViewControllers.swift
//  Gabb
//
//  Created by Evan Waters on 4/9/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: Embedding View Controllers -
    
    func embedViewController(vc : UIViewController, intoView superview : UIView) {
        self.addChildViewController(vc)
        superview.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    

    
    func removeEmbeddedViewController(vc : UIViewController) {
        vc.willMoveToParentViewController(self)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    func fetchViewController(storyboardName: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(storyboardIdentifier)
        return vc
    }
    
}