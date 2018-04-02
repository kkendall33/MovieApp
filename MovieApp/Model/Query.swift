//
//  Query.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import CoreData

/// Struct to represent a Query. Safe to use in UI.
struct Query {
    let term: String
    let creationDate: Date
}

extension Query {
    
    /// Convert `QueryCore` into a `Query`
    ///
    /// - Parameter queryCore: core data object that is equivalent to `Query`. Do not use `QueryCore`
    /// in the UI. Use `Query` instead.
    init(queryCore: QueryCore) {
        self.term = queryCore.term
        self.creationDate = queryCore.creationDate
    }
    
    /// Fetch queries with a given limit.
    ///
    /// - Parameter limit: The max number of queries to fetch.
    /// - Returns: Array of query sorted by recency.
    static func fetchQueries(limit: Int) -> [Query] {
        let fetchRequest: NSFetchRequest<QueryCore> = QueryCore.fetchRequest()
        fetchRequest.sortDescriptors = [QueryCore.creationDateSortDescriptor]
        fetchRequest.fetchLimit = limit
        
        var queries: [Query] = []
        // Use a private context but block the current queue. Can't use main because we don't know if
        // we are on main thread now.
        movieStore.privateContextAndWait { context in
            if let queryCores = try? context.fetch(fetchRequest) {
                queries = queryCores.toQueries()
            }
        }
        return queries
    }
    
}

extension Array where Element: QueryCore {
    
    /// Convert array of `QueryCore` into `Query` objects
    ///
    /// - Returns: Array of `Query` objects.
    func toQueries() -> [Query] {
        var queries: [Query] = []
        for queryCore in self {
            queries.append(Query(queryCore: queryCore))
        }
        return queries
    }
    
}

