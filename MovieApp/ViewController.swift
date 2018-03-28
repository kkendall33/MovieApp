//
//  ViewController.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let service = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? movieStore.saveContext()
        
        service.requestMovies(term: nil, page: 0) { data, error in
            print("hey")
            if let data = data {
                print("got data")
            }
            
            if let error = error {
                print("got error: \(error)")
            }
        }
        
    }
    
}

