//
//  TableViewInsetsAdjusting.swift
//  MovieApp
//
//  Created by Kyle Kendall on 4/1/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

protocol TableViewInsetsAdjusting: class {
    var tableView: UITableView! { get }
    var view: UIView! { get set }
    
    /// Has default implementation
    func keyboardWillChangeHeight(withNotification notification: Foundation.Notification)
    /// Has default implementation
    func keyboardDidChangeHeight(withNotification notification: Foundation.Notification)
}

extension TableViewInsetsAdjusting {
    func keyboardWillChangeHeight(withNotification notification: Foundation.Notification) { }
    func keyboardDidChangeHeight(withNotification notification: Foundation.Notification) { }
}

private var keyboardHeightAssociationKey: UInt8 = 0

extension TableViewInsetsAdjusting {
    
    var keyboardHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &keyboardHeightAssociationKey) as? CGFloat ?? 0.0
        }
        set(newValue) {
            objc_setAssociatedObject(self, &keyboardHeightAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    /// No need to remove the observers because they will now be removed on dealloc of the object.
    func setupInsetAdjust() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardChanged(notification)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardChanged(notification)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardChanged(notification)
        }
    }
    
    func keyboardChanged(_ notification: Foundation.Notification) {
        let height = self.view.keyboardHeightFromBottomWithNotification(notification)
        
        keyboardWillChangeHeight(withNotification: notification)
        var tableViewInset = tableView.contentInset
        tableViewInset.bottom = height
        
        tableView.scrollIndicatorInsets = tableViewInset
        tableView.contentInset = tableViewInset
        
        keyboardHeight = height
        keyboardDidChangeHeight(withNotification: notification)
    }
    
}


extension UIView {
    
    @discardableResult public func keyboardHeightFromBottomWithNotification(_ notification: Foundation.Notification) -> CGFloat {
        guard let userInfo = notification.userInfo as? [String:Any] else { return 0 }
        guard let rectValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return 0 }
        
        guard let window = self.window else {
            // If no window, use UIScreen. May be innaccurate for iPad, but since we only care about height, it is more accurate than not having this.
            let convertedFrame = self.convert(rectValue.cgRectValue, from: UIScreen.main.coordinateSpace)
            return convertedFrame.intersection(self.bounds).height
        }
        
        let convertedFrame = self.convert(rectValue.cgRectValue, from: window)
        return convertedFrame.intersection(self.bounds).height
    }
    
}

