//
//  Endpoints.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation


/// Use this caseless enum to hold all endpoints
/// (using an enum as a 'namespace')
enum Endpoints {
    /// List of movies sorted by relevance, paged.
    static let movies: String = "/3/search/movie"
    /// Image file with given file size.
    static let image: String = "/t/p/{fileSize}"
}
