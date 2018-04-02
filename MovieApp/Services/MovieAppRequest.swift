//
//  MovieAppRequest.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import Foundation


/// Key used to access the movie database
let tmdbAPIKey = "2696829a81b1b5827d515ff121700838"

/// movie database request with domain
let tmdbRequest: Request = Request(domain: "api.themoviedb.org")

/// Image request with image domain
let imageRequest: Request = Request(domain: "image.tmdb.org")
