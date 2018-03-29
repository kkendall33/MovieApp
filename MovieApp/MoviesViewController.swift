//
//  ViewController.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    private let imageService = ImageService()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? movieStore.saveContext()
        
        Movie.requestMovies(with: "bat", page: 1) { movies, error in
            print("movies: \(movies)")
        }
    }
    
}

