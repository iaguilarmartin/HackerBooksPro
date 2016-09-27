import Foundation
import CoreData

public class BookTag: NSManagedObject {
    static let entityName = "BookTag"
    
    //MARK: - Initializer
    convenience init (book: Book, tag: Tag, inContext context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.book = book
        self.tag = tag
    }
}
