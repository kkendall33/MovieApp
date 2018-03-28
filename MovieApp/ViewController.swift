//
//  ViewController.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let movieService = MovieService()
    private let imageService = ImageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? movieStore.saveContext()
        
        movieService.requestMovies(term: "batman", page: 1) { data, error in
            print("hey")
            if let data = data {
                print("got data")
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                print("\(json)")
            }
            
            if let error = error {
                print("got error: \(error)")
            }
        }
        
        imageService.downloadImage(with: "/bI1YVuhBN6Vws1GP9Mf01DyhC2s.jpg", imageSize: .w92) { url, error in
            if let url = url {
                print("url: \(url)")
            }
            if let error = error {
                print("error: \(error)")
            }
        }
        
    }
    
}

