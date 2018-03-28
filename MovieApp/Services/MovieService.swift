//
//  MovieService.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

class MovieService {
    
    func requestMovies(term: String? = nil, page: Int, with completion: @escaping (_ data: Data?, _ error: Error?)->()) -> URLSessionDataTask? {
        var queryItems: [URLQueryItem] = []
        let apiKey = URLQueryItem(name: "api_key", value: tmdbAPIKey)
        queryItems.append(apiKey)
        let page = URLQueryItem(name: "page", value: page.stringValue)
        queryItems.append(page)
        if let term = term {
            let termQuery = URLQueryItem(name: "query", value: term)
            queryItems.append(termQuery)
        }
        let task = tmdbRequest.request(with: Endpoints.movies, queryItems: queryItems) { data, response, error in
            completion(data, error)
        }
        task?.resume()
        return task
    }
    
}

