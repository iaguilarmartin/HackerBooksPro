import Foundation
import CoreData
import UIKit
import CoreLocation
import MapKit

public class Annotation: NSManagedObject {
    static let entityName = "Annotation"
    
    var locationManager: CLLocationManager?
    
    //MARK: - Initializer
    convenience init(text: String, book: Book, context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.book = book
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        self.text = text
        self.photo = Image(context: context)
    }
}

// MARK: - CLLocationManager
extension Annotation {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // Check if current context has no parent
        // in order to execute this code just once
        if self.managedObjectContext?.parent != nil {
            
            // Requesting current user location
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
    
    // Function to stop receiving locations
    func stopRequestingLocations() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil
    }
}

// MARK: - CLLocationManagerDelegate
extension Annotation: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Storing current user location into the model
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

// MARK: - MKAnnotation
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
