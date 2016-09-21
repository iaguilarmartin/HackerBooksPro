//
//  Cover+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 18/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Cover: NSManagedObject {
    static let entityName = "Cover"
    
    private var downloadState: DownloadState = .notDownloaded
    private var imageURL: URL?
    
    var delegate: CoverDelegate?
    
    var image: UIImage? {
        get {
            if downloadState == .notDownloaded {
                downloadState = .downloading
                
                print("Downloading cover: ", self.imageURL!);

                DispatchQueue.global(qos: .default).async {
                    if let imageData = try? Data(contentsOf: self.imageURL!) {
                        self.imageData = imageData as NSData?
                        self.downloadState = .downloaded
                        self.delegate?.imageDownloaded(self)
                    } else {
                        self.downloadState = .notDownloaded
                    }
                }
            }
            
            return UIImage(data: imageData! as Data)
        }
        set {
            guard let img = newValue else {
                imageData = nil
                return
            }
            
            imageData = UIImageJPEGRepresentation(img, 0.9) as NSData?
        }
    }
    
    //MARK: - Initializer
    convenience init (imageURL: URL, inContext context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Cover.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.imageURL = imageURL
        let defaultImage = Bundle.main.url(forResource: "emptyBookCover", withExtension: "png")!
        self.imageData = try! Data(contentsOf: defaultImage) as NSData?
    }
}

protocol CoverDelegate {
    func imageDownloaded(_ sender: Cover)
}
