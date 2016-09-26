//
//  MapViewController.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 25/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var request: NSFetchRequest<Annotation>
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext, request: NSFetchRequest<Annotation>) {
        self.request = request
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        var zoomRect: MKMapRect = MKMapRectNull
        
        if let annotations = try? self.context.fetch(request) {
            let filteredAnnos = annotations.filter({
                if $0.location != nil {
                    let annotationPoint = MKMapPointForCoordinate($0.coordinate)
                    let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                    return true
                } else {
                    return false
                }
            })
            
            self.mapView.addAnnotations(filteredAnnos)
        }
        
        self.mapView.setRegion(MKCoordinateRegionForMapRect(zoomRect), animated: false)
    }
}
