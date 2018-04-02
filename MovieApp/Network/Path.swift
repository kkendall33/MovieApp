//
//  Path.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

/// Simiplify path creation
public class Path {
    
    /// Error when creating a path
    ///
    /// - invalidPathArgument: the path is invalid
    /// - invalidOriginalPath: the original path is invalid
    public enum PathError: Error {
        case invalidPathArgument
        case invalidOriginalPath
    }
    
    /// A path argument
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
    
    /// The actual path that can be used to make a request.
    private(set) var path: String = ""
    /// The original path provided to this `Path` instance.
    private(set) var originalPath: String
    /// The arguments used in the path. Must correspond with `originalPath`
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
