import UIKit
import CoreData

// Table View Controller to display an UITabBarController with two tabs
// One tab for displaying annotations inside a table and another tab to
// pin them in a MapVIew
class AnnotationsViewController: UITabBarController {
    
    var model: Book
    
    //MARK: - Initializers
    init(book: Book) {
        self.model = book
        super.init(nibName: nil, bundle: nil)
        
        // Fetching annotations asociated with the book
        let fetchRequest = NSFetchRequest<Annotation>(entityName: Annotation.entityName)
        fetchRequest.fetchBatchSize = 50
        fetchRequest.predicate = NSPredicate(format: "book = %@", book)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        // Creating a view controller for each tab
        let annoVC = CollectionViewController(context: book.managedObjectContext!, request: fetchRequest)
        annoVC.title = "Collection"
        
        let mapVC = MapViewController(context: book.managedObjectContext!,request: fetchRequest)
        mapVC.title = "Map"
        
        self.setViewControllers([annoVC, mapVC], animated: true)
        
        // Setting view controller icon for each tab
        self.tabBar.items?[0].image = UIImage(imageLiteralResourceName: "thumbnails.png")
        self.tabBar.items?[1].image = UIImage(imageLiteralResourceName: "map.png")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension AnnotationsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Annotations"
        
        // Creating "new annotation" button inside navigation bar
        let newAnnoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAnnotation))
        self.navigationItem.rightBarButtonItem = newAnnoButton
    }
}

//MARK: - Functions
extension AnnotationsViewController {

    func addAnnotation() {
        
        // New annotation is created
        let newAnno = Annotation(text: "New annotation", book: self.model, context: self.model.managedObjectContext!)
        
        // Navigation to AnnotationViewController in order to display
        // just created annotation
        let annotationVC = AnnotationViewController(annotation: newAnno)
        self.navigationController?.pushViewController(annotationVC, animated: true)
    }
}
