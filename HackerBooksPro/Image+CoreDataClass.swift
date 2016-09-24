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
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Image.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        let emptyImage = UIImage(imageLiteralResourceName: "noImage.png")
        self.imageData = UIImageJPEGRepresentation(emptyImage, 0.9) as NSData!
    }
    
}
