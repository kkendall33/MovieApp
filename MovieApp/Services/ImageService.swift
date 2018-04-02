//
//  ImageService.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation

/// Image service used to download images from the image server.
final class ImageService {
    
    /// Download an image from the image server
    ///
    /// - Parameters:
    ///   - filePath: The path of the image to download
    ///   - imageSize: The size of the image to download
    ///   - completion: Completion called on return
    /// - Returns: Download task. Can be used to cancel.
    @discardableResult
    func downloadImage(with filePath: String, imageSize: ImageSize, completion: @escaping (_ fileURL: URL?, _ error: Error?)->()) -> URLSessionDownloadTask? {
        let pathArgument = Path.Argument(key: "fileSize", value: imageSize.rawValue)
        guard let path = try? Path(originalPath: Endpoints.image, pathArguments: [pathArgument]) else { return nil }
        let task = imageRequest.download(with: path.path + filePath) { fileURL, response, error in
            completion(fileURL, error)
        }
        task?.resume()
        return task
    }
    
}
