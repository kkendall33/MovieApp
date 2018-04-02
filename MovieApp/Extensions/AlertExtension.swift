//
//  AlertExtension.swift
//  MovieApp
//
//  Created by Kyle Kendall on 4/2/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    static var okayButtonTitle: String {
        return NSLocalizedString("Okay", comment: "Action to cancel on an alert")
    }
    
    class func okayAction(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: UIAlertAction.okayButtonTitle, style: UIAlertActionStyle.default, handler: handler)
    }
    
}

extension UIAlertController {
    
    func addOkayAction(_ handler: ((UIAlertAction) -> Void)? = nil) {
        self.addAction( UIAlertAction.okayAction(handler) )
    }
    
}
