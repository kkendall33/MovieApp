//
//  ViewController.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

private let defaultMoviesPage = 1
private let moviePageOffset = 3

/// Displays a search bar and movies if they match the search term.
final class MoviesViewController: UIViewController {
    
    private let imageService = ImageService()
    
    @IBOutlet private weak var tableView: UITableView!
    private var previousPage: Int = defaultMoviesPage
    private var didReachEnd = false
    private var loadingMovies = false
    private var searchTerm = "" {
        didSet {
            didReachEnd = false
            if searchTerm.isEmpty {
                movies = []
            } else {
                requestMovies(with: searchTerm, page: defaultMoviesPage)
            }
            updateQuerySuggestionsDisplay()
            querySuggestionsViewController.updateQueries()
        }
    }
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("Search", comment: "Placeholder text that is displayed in a search bar.")
        searchBar.delegate = self
        return searchBar
    }()
    private var searchBarHasFocus = false
    private var urlSession: URLSessionDataTask? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    lazy private var querySuggestionsViewController: QuerySuggestionsViewController = {
        let viewController = QuerySuggestionsViewController.viewControllerFromStoryboard()
        viewController.delegate = self
        return viewController
    }()
    
    private var movies: [Movie] = [] {
        didSet {
            tableView.reloadData()
            updateQuerySuggestionsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.titleView = searchBar
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
                if error?.isCancelledError == true {
                    // Don't show any alerts if they typed quick enough to cancel the previous request.
                    return
                }
                guard let movieResponse = movieResponse else {
                    _self.presentNoMoviesAlert(for: term)
                    return
                }
                if movieResponse.movies.count == 0 && page == defaultMoviesPage {
                    _self.presentNoMoviesAlert(for: term)
                }
                if error != nil {
                    _self.presentUnkownErrorAlert()
                }
                _self.updateView(with: movieResponse, currentPage: page)
            }
        }
    }
    
    private func updateView(with movieResponse: Movie.MovieResponse, currentPage: Int) {
        let didReachEnd = movieResponse.totalPages <= movieResponse.page
        
        if currentPage == defaultMoviesPage {
            tableView.setContentOffset(CGPoint.zero, animated: false)
            movies = movieResponse.movies
        } else if didReachEnd == false {
            movies = movies + movieResponse.movies
        }
        self.didReachEnd = didReachEnd
    }
    
    private func noMoviesAlert(for term: String) -> UIAlertController {
        let alertTitle = NSLocalizedString("Oops.. We couldn't find any matches", comment: "Title of alert that was shown because the search term didn't match any results")
        let alertMessage = NSLocalizedString("We couldn't find a movie with the title `%@`. Please try another term.", comment: "Title of alert that was shown because the search term didn't match any results")
        let formattedAlertMessage = String(format: alertMessage, term)
        let alertController = UIAlertController(title: alertTitle, message: formattedAlertMessage, preferredStyle: .alert)
        alertController.addOkayAction()
        return alertController
    }
    
    private func presentNoMoviesAlert(for term: String) {
        let alert = noMoviesAlert(for: term)
        present(alert, animated: true, completion: nil)
    }
    
    private func unkownErrorAlert() -> UIAlertController {
        let alertTitle = NSLocalizedString("Oops.. Something went wrong", comment: "Title of alert that was shown because the search term didn't match any results")
        let alertMessage = NSLocalizedString("Unfortunately something went wrong with your search. Please try again later.", comment: "Title of alert that was shown because the search term didn't match any results")
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addOkayAction()
        return alertController
    }
    
    private func presentUnkownErrorAlert() {
        let alert = unkownErrorAlert()
        present(alert, animated: true, completion: nil)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= movies.count - moviePageOffset && loadingMovies == false && didReachEnd == false {
            requestMovies(with: searchTerm, page: previousPage+1)
        }
    }
    
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText
        updateQuerySuggestionsDisplay()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarHasFocus = true
        updateQuerySuggestionsDisplay()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarHasFocus = false
        updateQuerySuggestionsDisplay()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
    
}

extension MoviesViewController {
    
    private func updateQuerySuggestionsDisplay() {
        if movies.count == 0 && searchBarHasFocus && searchBar.text?.isEmpty == true {
            addQuerySuggestionsIfNeeded()
        } else {
            removeQuerySuggestionsIfNeeded()
        }
    }
    
    private func addQuerySuggestionsIfNeeded() {
        guard querySuggestionsViewController.view.superview == nil else { return }
        addChildViewController(querySuggestionsViewController)
        querySuggestionsViewController.view.frame = view.frame
        view.addSubview(querySuggestionsViewController.view)
        querySuggestionsViewController.didMove(toParentViewController: self)
    }
    
    private func removeQuerySuggestionsIfNeeded() {
        querySuggestionsViewController.willMove(toParentViewController: nil)
        querySuggestionsViewController.view.removeFromSuperview()
        querySuggestionsViewController.removeFromParentViewController()
    }
    
}

extension MoviesViewController: QuerySuggestionsViewControllerDelegate {
    
    func querySuggestionsViewController(querySuggestionsViewController: QuerySuggestionsViewController, didSelect query: Query) {
        searchBar.text = query.term
        searchTerm = query.term
    }
    
}

