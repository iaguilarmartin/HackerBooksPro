import Foundation
import CoreData
import UIKit

public class Image: NSManagedObject {
    
    static let entityName = "Image"
    
    var image: UIImage {
        get {
            return UIImage(data: self.imageData! as Data)!
        }
        set {
            self.imageData = UIImageJPEGRepresentation(newValue, 0.9) as NSData!
        }
    }
    
    //MARK: - Initializer
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Image.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        restoreDefaultImage()
    }
}

extension Image {
    func restoreDefaultImage() {
        let emptyImage = UIImage(imageLiteralResourceName: "noImage.png")
        self.imageData = UIImageJPEGRepresentation(emptyImage, 0.9) as NSData!
    }
}
