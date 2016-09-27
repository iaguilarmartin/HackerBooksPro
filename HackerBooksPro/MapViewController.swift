import UIKit
import CoreData
import MapKit

// View Controller to display Annotation data
class MapViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    var request: NSFetchRequest<Annotation>
    var context: NSManagedObjectContext
    
    //MARK: - Initializers
    init(context: NSManagedObjectContext, request: NSFetchRequest<Annotation>) {
        self.request = request
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension MapViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clearing annotations from MapView
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // Property to store extent created with all annotations coordinates
        var zoomRect: MKMapRect = MKMapRectNull
        
        if let annotations = try? self.context.fetch(request) {
            
            // Filtering annotations with a valid location
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
        
        // Setting MapVIew initial region
        self.mapView.setRegion(MKCoordinateRegionForMapRect(zoomRect), animated: false)
    }
}
