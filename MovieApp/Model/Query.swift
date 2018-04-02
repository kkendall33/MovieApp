//
//  Query.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import CoreData

struct Query {
    let term: String
    let creationDate: Date
}

extension Query {
    
    init(queryCore: QueryCore) {
        self.term = queryCore.term
        self.creationDate = queryCore.creationDate
    }
    
    static func fetchQueries(limit: Int) -> [Query] {
        let fetchRequest: NSFetchRequest<QueryCore> = QueryCore.fetchRequest()
        fetchRequest.sortDescriptors = [QueryCore.creationDateSortDescriptor]
        fetchRequest.fetchLimit = limit
        
        var queries: [Query] = []
        movieStore.privateContextAndWait { context in
            if let queryCores = try? context.fetch(fetchRequest) {
                queries = queryCores.toQueries()
            }
        }
        return queries
    }
    
}

extension Array where Element: QueryCore {
    
    func toQueries() -> [Query] {
        var queries: [Query] = []
        for queryCore in self {
            queries.append(Query(queryCore: queryCore))
        }
        return queries
    }
    
}

