//
//  Document+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 21/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation
import CoreData


public class Document: NSManagedObject {
    static let entityName = "Document"
    
    var data: Data {
        get {
            if documentData == nil {
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
