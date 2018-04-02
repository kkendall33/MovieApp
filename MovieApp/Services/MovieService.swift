//
//  MovieService.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

/// The service used to make requests to the movie database.
final class MovieService {
    
    /// Service used to request movies.
    ///
    /// - Parameters:
    ///   - term: term used to query the movie database
    ///   - page: The page of movies to fetch
    ///   - completion: The closure called when the request completes
    /// - Returns: The session data task. Can be used to cancel.
    @discardableResult
    func requestMovies(term: String, page: Int, with completion: @escaping (_ data: Data?, _ error: Error?)->()) -> URLSessionDataTask? {
        let apiKey = URLQueryItem(name: "api_key", value: tmdbAPIKey)
        let page = URLQueryItem(name: "page", value: page.stringValue)
        let termQuery = URLQueryItem(name: "query", value: term)
        
        let queryItems: [URLQueryItem] = [apiKey, page, termQuery]
        let task = tmdbRequest.request(with: Endpoints.movies, queryItems: queryItems) { data, response, error in
            completion(data, error)
        }
        task?.resume()
        return task
    }
    
}

