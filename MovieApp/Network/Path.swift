//
//  Path.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

public class Path {
    
    public enum PathError: Error {
        case invalidPathArgument
        case invalidOriginalPath
    }
    
    public struct Argument {
        let key: String
        let value: String
    }
    
    public init(originalPath: String, pathArguments: [Argument]) throws {
        self.originalPath = originalPath
        self.pathArguments = pathArguments
        try validatePath()
        try updatePath()
    }
    
    private(set) var path: String = ""
    private(set) var originalPath: String
    private(set) var pathArguments: [Argument]
    
    private func updatePath() throws {
        path = originalPath
        
        for pathArgument in pathArguments {
            let previousPath = path
            path = path.replacingOccurrences(of: "{\(pathArgument.key)}", with: pathArgument.value)
            if path == previousPath {
                throw PathError.invalidPathArgument
            }
        }
    }
    
    private func validatePath() throws {
        if originalPath == "" {
            throw PathError.invalidOriginalPath
        }
    }
    
}
