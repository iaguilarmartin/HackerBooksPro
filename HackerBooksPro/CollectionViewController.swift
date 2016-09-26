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

    init(context: NSManagedObjectContext, request: NSFetchRequest<Annotation>) {
        let fetchedResultsController = NSFetchedResultsController<Annotation>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
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
        cell?.imageView?.image = annotation.photo?.image
        cell?.detailTextLabel?.text = annotation.location?.address
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let annotation = fetchedResultsController?.object(at: indexPath) as! Annotation
        let annotationVC = AnnotationViewController(annotation: annotation)
        self.navigationController?.pushViewController(annotationVC, animated: true)
    }
}
