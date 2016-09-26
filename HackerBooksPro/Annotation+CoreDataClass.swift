//
//  Annotation+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 24/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation
import MapKit

public class Annotation: NSManagedObject {
    static let entityName = "Annotation"
    
    var locationManager: CLLocationManager?
    
    convenience init(text: String, book: Book, context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.book = book
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        self.text = text
        self.photo = Image(context: context)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        if self.managedObjectContext?.parent != nil {
            let locationStatus = CLLocationManager.authorizationStatus()
            if (locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse || locationStatus == .notDetermined) && CLLocationManager.locationServicesEnabled() {
                
                self.locationManager = CLLocationManager()
                self.locationManager?.requestWhenInUseAuthorization()
                self.locationManager?.delegate = self
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                
                self.locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func stopRequestingLocations() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil
    }
}

extension Annotation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.location == nil {
            if let lastLocation = locations.last {
                self.location = Location(location: lastLocation, annotation: self, context: self.managedObjectContext!)
                self.stopRequestingLocations()
            }
        } else {
            self.stopRequestingLocations()
        }
    }
}

extension Annotation: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        get {
            guard let location = self.location else {
                return kCLLocationCoordinate2DInvalid
            }
            
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    public var title: String? {
        get {
            return self.text
        }
    }
    
    public var subtitle: String? {
        get {
            return self.location?.address
        }
    }
}
