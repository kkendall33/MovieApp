//
//  AlertExtension.swift
//  MovieApp
//
//  Created by Kyle Kendall on 4/2/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

// Careem: I use these extensions a lot in my side apps. Just a quick way to add frequently
// used things on UIAlertAction and UIAlertController.

import UIKit

extension UIAlertAction {
    
    /// Frequently used okay title for an action
    static var okayButtonTitle: String {
        return NSLocalizedString("Okay", comment: "Action to cancel on an alert")
    }
    
    /// Frequently used okay action
    class func okayAction(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: UIAlertAction.okayButtonTitle, style: UIAlertActionStyle.default, handler: handler)
    }
    
}

extension UIAlertController {
    
    /// Frequently used quick add for okayAction
    func addOkayAction(_ handler: ((UIAlertAction) -> Void)? = nil) {
        self.addAction( UIAlertAction.okayAction(handler) )
    }
    
}
