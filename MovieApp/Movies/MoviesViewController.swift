//
//  ViewController.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

private let defaultMoviesPage = 1

final class MoviesViewController: UIViewController {
    
    private let imageService = ImageService()
    
    @IBOutlet private weak var tableView: UITableView!
    private var previousPage: Int = defaultMoviesPage
    private var didReachEnd = false
    private var loadingMovies = false
    private var searchTerm = "" {
        didSet {
            didReachEnd = false
            requestMovies(with: searchTerm, page: defaultMoviesPage)
        }
    }
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("Search", comment: "Placeholder text that is displayed in a search bar.")
        searchBar.delegate = self
        return searchBar
    }()
    private var urlSession: URLSessionDataTask? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    private var movies: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.titleView = searchBar
        try? movieStore.saveContext()
        searchTerm = "b"
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(MovieCell.self)
    }
    
    private func requestMovies(with term: String, page: Int) {
        previousPage = page
        loadingMovies = true
        urlSession = Movie.requestMovies(with: term, page: page) { [weak self] movieResponse, error in
            DispatchQueue.main.async {
                self?.loadingMovies = false
                guard let _self = self else { return }
                guard let movieResponse = movieResponse else { return }
                // Handle errors here
                if error != nil {
                    print("error: \(error)")
                }
                
                if page == defaultMoviesPage {
                    _self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    _self.movies = movieResponse.movies
                } else {
                    _self.movies = _self.movies + movieResponse.movies
                }
                _self.didReachEnd = movieResponse.totalPages == movieResponse.page
            }
        }
    }
    
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dequeueCell(for: indexPath)
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
}

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= movies.count - 3 && loadingMovies == false && didReachEnd == false {
            requestMovies(with: searchTerm, page: previousPage+1)
        }
    }
    
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText
    }
    
}

