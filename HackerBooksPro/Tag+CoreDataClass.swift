//
//  Tag+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 18/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation
import CoreData


public class Tag: NSManagedObject {
    static let entityName = "Tag"
    
    //MARK: - Initializer
    convenience init (name: String, inContext context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.name = name
    }
    
    static func searchOrCreate(name: String, inContext context: NSManagedObjectContext) -> Tag {
        
        let request = NSFetchRequest<Tag>(entityName: Tag.entityName)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let tags = try? context.fetch(request), let tag = tags.first {
            return tag
        } else {
            return Tag(name: name, inContext: context)
        }
    }
    
}
