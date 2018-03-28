//
//  Network.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

//let path = "/3/search/movie"
//let hd = "api_key=2696829a81b1b5827d515ff121700838&query=batman&page=1"
//let movieDomain = "api.themoviedb.org"
//
//let imageDomain = "image.tmdb.org/t/p/w92/2DtPSyODKWXluIRV7PVru0SSzja.jpg"

class Request {
    
    private enum Method: String {
        case get = "GET"
    }
    
    var domain: String
    
    var scheme = "http"
    
    private let timeout: TimeInterval = 45
    private(set) var urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    
    init(domain: String) {
        self.domain = domain
    }
    
    func request(with path: String, queryItems: [URLQueryItem], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()) -> URLSessionDataTask? {
        
        var components = URLComponents()
        components.host = domain
        components.path = path
        components.scheme = scheme
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout)
        request.httpMethod = Method.get.rawValue
        
        return urlSession.dataTask(with: request, completionHandler: completion)
    }
    
}
