import Foundation
import CoreData
import UIKit

public class Cover: NSManagedObject {
    static let entityName = "Cover"

    // Converting imade data to an UIImage
    var image: UIImage? {
        get {
            
            // Checking if Cover already has an image data value
            if imageData == nil {
                
                // if not image data is initialized with a default value
                // while definitive image is downloaded from remote server
                let defaultImage = Bundle.main.url(forResource: "emptyBookCover", withExtension: "png")!
                self.imageData = try! Data(contentsOf: defaultImage) as NSData?
                
                if let urlString = self.imageURL,
                    let url = URL(string: urlString) {
                    
                    print("Downloading cover: ", url);
                    
                    DispatchQueue.global(qos: .default).async {
                        if let imageData = try? Data(contentsOf: url) {
                            self.imageData = imageData as NSData?
                            DispatchQueue.main.async {
                                self.book?.imageDownloaded()
                            }
                        }
                    }
                }
            }
            
            return UIImage(data: self.imageData! as Data)
        }
    }
    
    //MARK: - Initializer
    convenience init (imageURL: String, inContext context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Cover.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.imageURL = imageURL
    }
}
