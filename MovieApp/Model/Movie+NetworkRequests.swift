//
//  Movie+Service.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

private let movieService = MovieService()

extension Movie {
    
    struct MovieResponse: Codable {
        let totalPages: Int
        let totalResults: Int
        let page: Int
        let movies: [Movie]
        
        enum CodingKeys: String, CodingKey {
            case totalPages = "total_pages"
            case totalResults = "total_results"
            case page
            case movies = "results"
        }
        
    }
    
    
    @discardableResult
    static func requestMovies(with term: String, page: Int, saveQuery: Bool, completion: @escaping (_ movieResponse: MovieResponse?, _ error: Error?)->()) -> URLSessionDataTask? {
        return movieService.requestMovies(term: term, page: page) { data, error in
            var movie: MovieResponse?
            defer {
                if error == nil && page == 1, let movie = movie, movie.movies.count > 0 && saveQuery {
                    movieStore.privateContext { context in
                        QueryCore.updateQuery(with: term, in: context)
                        try? context.save()
                    }
                }
                completion(movie, error)
            }
            if let data = data, let movieResponse = try? JSONDecoder().decode(Movie.MovieResponse.self, from: data) {
                movie = movieResponse
            }
        }
    }
    
}
