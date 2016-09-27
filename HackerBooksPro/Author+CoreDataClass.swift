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
}

extension Author {
    
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
