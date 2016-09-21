//
//  BooksViewController.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 18/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit
import CoreData

class BooksViewController: CoreDataTableViewController {
    static let selectedBookChanged = "SelectedBookChangedNotification"
    static let selectedBookKey = "book"
    
    var alphabeticalFetchedResultsController: NSFetchedResultsController<Book>
    var tagsFetchedResultsController: NSFetchedResultsController<BookTag>
    var segmentedControl: UISegmentedControl
    var delegate: BooksViewControllerDelegate?
    
    init(context: NSManagedObjectContext) {
        let tagsRequest = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        tagsRequest.fetchBatchSize = 50
        tagsRequest.sortDescriptors = [NSSortDescriptor(key: "tag.name", ascending: true), NSSortDescriptor(key: "book.title", ascending: true)]
        self.tagsFetchedResultsController = NSFetchedResultsController(fetchRequest: tagsRequest, managedObjectContext: context, sectionNameKeyPath: "tag.name", cacheName: nil)
    
        let alphabeticalRequest = NSFetchRequest<Book>(entityName: Book.entityName)
        alphabeticalRequest.fetchBatchSize = 50
        alphabeticalRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.alphabeticalFetchedResultsController = NSFetchedResultsController(fetchRequest: alphabeticalRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.segmentedControl = UISegmentedControl(items: ["Tags", "Alphabetical"])
        
        super.init(fetchedResultsController: tagsFetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource
extension BooksViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        
        let nib = UINib(nibName: "BookViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookViewCell.cellId)
        
        // Replace the TitleView of the NavigationController with a SegmentedControl
        // to indicate if displaying books grouped by tag or ordered by title
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(selectedSegmentChanged), for: .valueChanged)
        
        self.navigationItem.titleView = self.segmentedControl
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let book = getBookAtIndexPath(indexPath)
        
        // Try to reuse an existing cell
        let cell: BookViewCell? = tableView.dequeueReusableCell(withIdentifier: BookViewCell.cellId, for: indexPath) as? BookViewCell
        
        // Get book to be displayed
        cell?.book = book

        // Devolverla
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return BookViewCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get selected book
        let book = getBookAtIndexPath(indexPath)
        
        // If current device is an iPad then existing BookViewController is informed that a
        // new book is selected. Else, app navigates to the a new BookViewController
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.delegate?.booksViewController(self, didSelectBook: book)
            
            let notif = Notification(name: Notification.Name(rawValue: BooksViewController.selectedBookChanged), object: self, userInfo: [BooksViewController.selectedBookKey: book])
            let notifCenter = NotificationCenter.default
            notifCenter.post(notif)
        } else {
            let bookVC = BookViewController(model: book)
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
}

extension BooksViewController {
    
    // Computed property to indicate if view is in alphabetical display mode
    var areTagsVisibles: Bool {
        get {
            return segmentedControl.selectedSegmentIndex == 0
        }
    }
    
    // Function called when the way of displaying books is changed. When that occurs
    // the table data needs to be reloaded
    func selectedSegmentChanged() {
        
        //Scroll the TableView to the first element
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        
        self.fetchedResultsController?.delegate = nil
        self.tagsFetchedResultsController.delegate = nil
        self.alphabeticalFetchedResultsController.delegate = nil
        
        if areTagsVisibles {
            self.fetchedResultsController = self.tagsFetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult>
        } else {
            self.fetchedResultsController = self.alphabeticalFetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult>
        }
    }
    
    func getBookAtIndexPath(_ path: IndexPath) -> Book {
        if areTagsVisibles {
            let bookTag = self.fetchedResultsController?.object(at: path) as! BookTag
            return bookTag.book!
        } else {
            return self.fetchedResultsController?.object(at: path) as! Book
        }
    }
}

protocol BooksViewControllerDelegate {
    func booksViewController(_ booksVC: BooksViewController, didSelectBook book: Book)
}

