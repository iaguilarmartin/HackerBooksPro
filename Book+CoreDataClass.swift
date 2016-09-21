//
//  Book+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 18/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation
import CoreData

public class Book: NSManagedObject {
    static let entityName = "Book"
    static let bookCoverChangedEvent = "BookFavoriteChangedNotification"
    static let bookChangedKey = "KeyBook"
    
    //MARK: - Initializer
    convenience init (title: String, authors: [String], tags: [String], cover: Cover, inContext context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.title = title
        
        cover.delegate = self
        self.cover = cover
        
        for authorName in authors {
            let author = Author.searchOrCreate(name: authorName, inContext: context)
            self.addToAuthors(author)
        }
        
        for tagName in tags {
            let tag = Tag.searchOrCreate(name: tagName, inContext: context)
            let bookTag = BookTag(book: self, tag: tag, inContext: context)
            tag.addToBookTags(bookTag)
            addToBookTags(bookTag)
        }
    }
    
    func sendNotification(name: String){
        let n = Notification(name: Notification.Name(rawValue: name), object: self, userInfo: [Book.bookChangedKey:self])
        let nc = NotificationCenter.default
        nc.post(n)
    }
    
    func authorNames() -> String {
        let authorsArray: [Author] = authors?.allObjects as! [Author]
        let names: [String] = authorsArray.map { return $0.name! }
        return names.joined(separator: ", ")
    }
    
    func tagNames() -> String {
        let bookTagsArray: [BookTag] = bookTags!.allObjects as! [BookTag]
        let names: [String] = bookTagsArray.map { return $0.tag!.name! }
        return names.joined(separator: ", ")
    }
}

extension Book: CoverDelegate {
    func imageDownloaded(_ sender: Cover) {
        self.cover = sender
        sendNotification(name: Book.bookCoverChangedEvent)
    }
}
