//
//  Movie.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let posterLocalPath: String
    let posterServerPath: String
    let name: String
    let overview: String
    let releaseDate: Date
}

enum ImageSize: String {
    case w92
    case w185
    case w500
    case w780
}
