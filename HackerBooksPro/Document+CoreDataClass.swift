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
    
    private var downloadState: DownloadState = .notDownloaded
    private var documentURL: URL?
    
    var delegate: DocumentDelegate?
    
    var data: Data {
        get {
            if downloadState == .notDownloaded {
                downloadState = .downloading
                
                print("Downloading document: ", self.documentURL!);
                
                DispatchQueue.global(qos: .default).async {
                    if let docData = try? Data(contentsOf: self.documentURL!) {
                        self.documentData = docData as NSData?
                        self.downloadState = .downloaded
                        self.delegate?.documentDownloaded(self)
                    } else {
                        self.downloadState = .notDownloaded
                    }
                }
            }
            
            return self.documentData as Data!
        }
    }
    
    //MARK: - Initializer
    convenience init (documentURL: URL, inContext context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Document.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.documentURL = documentURL
        let defaultDocument = Bundle.main.url(forResource: "emptyPdf", withExtension: "pdf")!
        self.documentData = try! Data(contentsOf: defaultDocument) as NSData?
    }
}

protocol DocumentDelegate {
    func documentDownloaded(_ sender: Document)
}
