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
    static let favoritesTagName = "favorites"
    
    // Check if tag name is equal default favorites tag name
    var isFavoriteTag: Bool {
        get {
            return name == Tag.favoritesTagName
        }
    }
    
    //MARK: - Initializer
    convenience init (name: String, inContext context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.name = name
        self.sortName = isFavoriteTag ? "_" + name : name
    }
    
    // Find an existing Tag by name or creates a new one if it donsen't exist
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
