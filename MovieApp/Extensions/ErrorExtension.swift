//
//  ErrorExtension.swift
//  MovieApp
//
//  Created by Kyle Kendall on 4/2/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

extension Error {
    
    var isCancelledError: Bool {
        let nsError = self as NSError
        return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled
    }
    
}
