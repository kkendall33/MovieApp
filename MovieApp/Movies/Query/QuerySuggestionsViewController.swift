//
//  QuerySuggestionsViewController.swift
//  MovieApp
//
//  Created by Kyle Kendall on 4/1/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import UIKit

/// Use this to communicate with another object anonymously.
protocol QuerySuggestionsViewControllerDelegate: class {
    func querySuggestionsViewController(querySuggestionsViewController: QuerySuggestionsViewController, didSelect query: Query)
}

/// Displays previous search terms
final class QuerySuggestionsViewController: UIViewController, StoryboardInstantiating, TableViewInsetsAdjusting {
    
    /// Set an object to this that will receive updates.
    var delegate: QuerySuggestionsViewControllerDelegate?
    
    /// Call this to update the queries displayed.
    func updateQueries() {
        queries = Query.fetchQueries(limit: 10)
    }
    
    static var storyboardName: String = "Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateQueries()
        setupTableView()
    }
    
    /// This must be internal to conform to `TableViewInsetsAdjusting`
    /// This is not for internal use.
    @IBOutlet var tableView: UITableView!
    
    private var queries: [Query] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.register(QueryCell.self)
        tableView.tableFooterView = UIView()
        setupInsetAdjust()
    }
    
}

extension QuerySuggestionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QueryCell = tableView.dequeueCell(for: indexPath)
        let query = queries[indexPath.row]
        cell.configure(with: query)
        return cell
    }
    
}

extension QuerySuggestionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let query = queries[indexPath.row]
        delegate?.querySuggestionsViewController(querySuggestionsViewController: self, didSelect: query)
    }
    
}

