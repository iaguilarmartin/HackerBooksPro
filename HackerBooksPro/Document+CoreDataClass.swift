import Foundation
import CoreData

public class Document: NSManagedObject {
    static let entityName = "Document"
    
    var data: Data {
        get {
            
            // Checking if Document already has an document data value
            if documentData == nil {
                
                // if not document data is initialized with a default value
                // while definitive document is downloaded from remote server
                let defaultDocument = Bundle.main.url(forResource: "emptyPdf", withExtension: "pdf")!
                self.documentData = try! Data(contentsOf: defaultDocument) as NSData?
                
                if let urlString = self.documentURL,
                    let url = URL(string: urlString) {
                    
                    print("Downloading document: ", self.documentURL!);
                    
                    DispatchQueue.global(qos: .default).async {
                        if let docData = try? Data(contentsOf: url) {
                            self.documentData = docData as NSData?
                            DispatchQueue.main.async {
                                self.book?.documentDownloaded()
                            }
                        }
                    }
                }

            }
            
            return self.documentData as Data!
        }
    }
    
    //MARK: - Initializer
    convenience init (documentURL: String, inContext context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Document.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.documentURL = documentURL
    }
}
