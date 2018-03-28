//
//  Network.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

final class Request {
    
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
    
    func request(with path: String, queryItems: [URLQueryItem] = [], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()) -> URLSessionDataTask? {
        guard let url = self.url(with: path, queryItems: queryItems) else { return nil }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout)
        request.httpMethod = Method.get.rawValue
        
        return urlSession.dataTask(with: request, completionHandler: completion)
    }
    
    func download(with path: String, queryItems: [URLQueryItem] = [], completion: @escaping (_ url: URL?, _ response: URLResponse?, _ error: Error?)->()) -> URLSessionDownloadTask? {
        guard let url = self.url(with: path, queryItems: queryItems) else { return nil }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout)
        request.httpMethod = Method.get.rawValue
        return urlSession.downloadTask(with: request, completionHandler: completion)
    }
    
    private func url(with path: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents()
        components.host = domain
        components.path = path
        components.scheme = scheme
        components.queryItems = queryItems
        return components.url
    }
    
}
