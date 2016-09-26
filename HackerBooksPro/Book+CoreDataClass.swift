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
    static let bookCoverChangedEvent = "BookCoverChangedNotification"
    static let bookDocumentChangedEvent = "BookDocumentChangedNotification"
    static let bookChangedKey = "KeyBook"
    static let lastReadedBookKey = "LastReaded"
    
    //MARK: - Initializer
    convenience init (title: String, authors: [String], tags: [String], cover: Cover, document: Document, inContext context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.title = title
        self.cover = cover
        self.document = document
        
        for authorName in authors {
            let author = Author.searchOrCreate(name: authorName, inContext: context)
            self.addToAuthors(author)
        }
    
        for tagName in tags {
            let tag = Tag.searchOrCreate(name: tagName, inContext: context)
            let _ = BookTag(book: self, tag: tag, inContext: context)
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
        var names: [String] = bookTagsArray.map { return $0.tag!.name! }
        names = names.filter { $0 != Tag.favoritesTagName }
        return names.joined(separator: ", ")
    }

    private func getFavoriteBookTag() -> BookTag? {
        if let array = bookTags?.allObjects as? [BookTag] {
            for bookTag in array {
                if (bookTag.tag?.isFavoriteTag)! {
                    return bookTag
                }
            }
        }
        
        return nil
    }
    
    func isFavoriteBook() -> Bool {
        if let _ = getFavoriteBookTag() {
            return true
        } else {
            return false
        }
    }
    
    func toggleFavoriteState() {
        if let favoriteBookTag = getFavoriteBookTag() {
            removeFromBookTags(favoriteBookTag)
            managedObjectContext?.delete(favoriteBookTag)
        } else {
            let favoritesTag = Tag.searchOrCreate(name: Tag.favoritesTagName, inContext: managedObjectContext!)
            let _ = BookTag(book: self, tag: favoritesTag, inContext: managedObjectContext!)
        }
    }
    
    func imageDownloaded() {
        sendNotification(name: Book.bookCoverChangedEvent)
    }
    
    func documentDownloaded() {
        sendNotification(name: Book.bookDocumentChangedEvent)
    }
}
