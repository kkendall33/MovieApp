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
        
        service.requestMovies(term: "batman", page: 1) { data, error in
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
        
    }
    
}

