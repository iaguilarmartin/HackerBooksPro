//
//  Document+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 23/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation
import CoreData

extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document");
    }

    @NSManaged public var documentData: NSData?
    @NSManaged public var documentURL: String?
    @NSManaged public var book: Book?

}
