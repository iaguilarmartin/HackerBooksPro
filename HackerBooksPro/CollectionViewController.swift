//
//  CollectionViewController.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 25/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: CoreDataTableViewController{

    var book: Book
    
    init(book: Book) {
        self.book = book
        
        let fetchRequest = NSFetchRequest<Annotation>(entityName: Annotation.entityName)
        fetchRequest.fetchBatchSize = 50
        fetchRequest.predicate = NSPredicate(format: "book = %@", book)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController<Annotation>(fetchRequest: fetchRequest, managedObjectContext: book.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init(fetchedResultsController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "AnnotationCell"
        let annotation = fetchedResultsController?.object(at: indexPath) as! Annotation
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        }
        
        cell?.textLabel?.text = annotation.text
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let annotation = fetchedResultsController?.object(at: indexPath) as! Annotation
        let annotationVC = AnnotationViewController(annotation: annotation)
        self.navigationController?.pushViewController(annotationVC, animated: true)
    }
}
