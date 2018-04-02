//
//  Network.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

/// Use this to make an HTTP request.
final class Request {
    
    private enum Method: String {
        case get = "GET"
    }
    
    /// The domain used to make the http request.
    private(set) var domain: String
    
    /// The scheme/protocol to make the network request. Expand as required.
    private enum Scheme: String {
        case http = "http"
    }
    
    private let timeout: TimeInterval = 45
    private(set) var urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    
    /// Provide a domain on which all request will be based
    ///
    /// - Parameter domain: domain to base all requests.
    init(domain: String) {
        self.domain = domain
    }
    
    /// Create a url session data task to make a network call.
    ///
    /// - Parameters:
    ///   - path: path to the resource(s) requested
    ///   - queryItems: queryItems used to specify resource
    ///   - completion: closure called when request returns
    /// - Returns: Data task used to make request
    func request(with path: String, queryItems: [URLQueryItem] = [], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()) -> URLSessionDataTask? {
        guard let url = self.url(with: path, queryItems: queryItems) else { return nil }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout)
        request.httpMethod = Method.get.rawValue
        
        return urlSession.dataTask(with: request, completionHandler: completion)
    }
    
    /// Download a file from another server via network
    ///
    /// - Parameters:
    ///   - path: Path to the file to be downloaded
    ///   - queryItems: queryItems used to specify file specs
    ///   - completion: closure called on completion. Contains the filepath where the file was downloaded
    /// - Returns: Download task used to make request.
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
        components.scheme = Scheme.http.rawValue
        components.queryItems = queryItems
        return components.url
    }
    
}
