import Foundation
import CoreData
import CoreLocation
import Contacts

public class Location: NSManagedObject {
    static let entityName = "Location"
    
    convenience init(location: CLLocation, annotation: Annotation, context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Location.entityName, in: context)
        self.init(entity: entityDescription!, insertInto: context)
        
        self.annotation = annotation
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude

        // Converting latitude & longitude values into a fisical address
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            
            if error != nil {
                print("Error while obtaining location address: %@", error?.localizedDescription)
                self.address = "Error"
            } else if let placemark = placemarks?.last, let addressList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                
                self.address = addressList.joined(separator: ", ")
            } else {
                self.address = "Unknown"
            }
            
            print("Location address is: ", self.address)
        }
    }
}
