//
//  Image+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 24/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

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
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Image.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        restoreDefaultImage()
    }
    
    func restoreDefaultImage() {
        let emptyImage = UIImage(imageLiteralResourceName: "noImage.png")
        self.imageData = UIImageJPEGRepresentation(emptyImage, 0.9) as NSData!
    }
}
