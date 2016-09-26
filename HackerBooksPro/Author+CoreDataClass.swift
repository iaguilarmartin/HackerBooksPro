//
//  Author+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 18/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation
import CoreData

public class Author: NSManagedObject {
    static let entityName = "Author"
    
    //MARK: - Initializer
    convenience init (name: String, inContext context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.name = name
    }
    
    // Find an existing Author by name or creates a new one if it donsen't exist
    static func searchOrCreate(name: String, inContext context: NSManagedObjectContext) -> Author {
        
        let request = NSFetchRequest<Author>(entityName: Author.entityName)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let authors = try? context.fetch(request), let author = authors.first {
            return author
        } else {
            return Author(name: name, inContext: context)
        }
    }
}
