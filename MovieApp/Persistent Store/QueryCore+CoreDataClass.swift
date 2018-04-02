//
//  QueryCore+CoreDataClass.swift
//  
//
//  Created by Kyle Kendall on 4/1/18.
//
//

import Foundation
import CoreData

@objc(QueryCore)
public class QueryCore: NSManagedObject {
    
    static var creationDateSortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: #keyPath(QueryCore.creationDate), ascending: false)
    }
    
    static func fetchQuery(with term: String, in context: NSManagedObjectContext) -> QueryCore? {
        let fetchRequest: NSFetchRequest<QueryCore> = QueryCore.fetchRequest()
        fetchRequest.fetchLimit = 1
        /// To remove `b` `ba` `bat` `batm` etc.
        let allButLastCharacterTerm = String(term[..<term.index(before: term.endIndex)])
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(QueryCore.term), allButLastCharacterTerm)
        
        let queries = (try? context.fetch(fetchRequest)) ?? []
        return queries.first
    }
    
    static func updateQuery(with term: String, in context: NSManagedObjectContext) {
        let query: QueryCore
        if let fetchedQuery = QueryCore.fetchQuery(with: term, in: context) {
            query = fetchedQuery
        } else {
            query = QueryCore(context: context)
        }
        query.term = term
        query.creationDate = Date()
    }
    
}
