//
//  QueryCore+CoreDataClass.swift
//  
//
//  Created by Kyle Kendall on 4/1/18.
//
//

// Careem: I use Core Data frequently as a persistent store. Some benefits are:
// - It's supported by Apple.
// - NSFetchedResultsController can simplify tables and is very memory efficient.
// - A lot of things are done for you, the layer above the DB helps with duplication and other things
// Downsides to using Core Data
// - Can be very complicated because so much code is between the DB and the dev.
// - Not built to be replacable. Must use contexts on right queues rather than passing data between queues/threads easily.

import Foundation
import CoreData

/// Core data class used to represent a persisted query.
/// Do NOT use this in UI. Use `Query` instead.
@objc(QueryCore)
public class QueryCore: NSManagedObject {
    
    /// Sort descriptor for the `creationDate` key
    static var creationDateSortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: #keyPath(QueryCore.creationDate), ascending: false)
    }
    
    private static func fetchQuery(with term: String, in context: NSManagedObjectContext) -> QueryCore? {
        let fetchRequest: NSFetchRequest<QueryCore> = QueryCore.fetchRequest()
        fetchRequest.fetchLimit = 1
        /// To remove `b` `ba` `bat` `batm` etc.
        let allButLastCharacterTerm = String(term[..<term.index(before: term.endIndex)])
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(QueryCore.term), allButLastCharacterTerm)
        
        let queries = (try? context.fetch(fetchRequest)) ?? []
        return queries.first
    }
    
    /// Use this to update the context with queries to keep the db clean.
    ///
    /// - Parameters:
    ///   - term: The term used to fetch or create a query
    ///   - context: context used to fetch object(s)
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
