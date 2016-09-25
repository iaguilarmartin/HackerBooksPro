//
//  AnnotationsViewController.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 24/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit
import CoreData

class AnnotationsViewController: UITabBarController {
    
    var model: Book
    
    init(book: Book) {
        self.model = book
        super.init(nibName: nil, bundle: nil)
        
        let annoVC = CollectionViewController(book: self.model)
        annoVC.title = "Collection"
        
        let mapVC = MapViewController(nibName: nil, bundle: nil)
        mapVC.title = "Map"

        self.setViewControllers([annoVC, mapVC], animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Annotations"
        let newAnnoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAnnotation))
        self.navigationItem.rightBarButtonItem = newAnnoButton
    }
    
    func addAnnotation() {
        let newAnno = Annotation(text: "Nueva anotación", book: self.model, context: self.model.managedObjectContext!)
        let annotationVC = AnnotationViewController(annotation: newAnno)
        self.navigationController?.pushViewController(annotationVC, animated: true)
    }
}
