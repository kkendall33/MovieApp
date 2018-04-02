//
//  QueryCore+CoreDataProperties.swift
//  
//
//  Created by Kyle Kendall on 4/1/18.
//
//

import Foundation
import CoreData


extension QueryCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QueryCore> {
        return NSFetchRequest<QueryCore>(entityName: "QueryCore")
    }

    @NSManaged public var term: String
    @NSManaged public var creationDate: Date

}
