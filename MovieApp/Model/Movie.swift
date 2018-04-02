//
//  Movie.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

struct Movie: Codable, Equatable {
    var posterLocalPath: String?
    let posterServerPath: String?
    let name: String
    let overview: String
    let releaseDate: Date?
    let identifier: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case overview
        case posterServerPath = "poster_path"
        case releaseDate = "release_date"
        case posterLocalPath = "poster_local_path"
        case identifier = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.overview = try container.decode(String.self, forKey: .overview)
        let textDateOptional = try? container.decode(String.self, forKey: .releaseDate)
        if let textDate = textDateOptional, let date = Movie.dateFormatter.date(from: textDate) {
            releaseDate = date
        } else {
            releaseDate = nil
        }
        self.posterServerPath = try? container.decode(String.self, forKey: .posterServerPath)
        self.identifier = try container.decode(Int.self, forKey: .identifier)
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.name == rhs.name &&
            lhs.overview == rhs.overview &&
            lhs.posterServerPath == rhs.posterServerPath &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.identifier == rhs.identifier
    }
    
}

extension Movie {
    static fileprivate let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    enum MovieError: Error {
        case invalidDate
    }
    
}

enum ImageSize: String {
    case w92
    case w185
    case w500
    case w780
}
