import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let model = CoreDataStack(modelName: "Model")!
    let appInitializedKey = "appinitialized"

    let autoSaveInterval = 10
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Creating books list ViewController
        var mainViewController: UIViewController
        let booksVC = BooksViewController(context: model.context)
        let booksNav = UINavigationController(rootViewController: booksVC)
        
        // If current device is an iPad then a SplitViewController is displayed
        // else LibraryViewController would be the main View Controller
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            // We need a BookViewController to display at the rigt side of the
            // SplitViewController
            let bookVC = BookViewController(model: nil)
            
            let bookNav = UINavigationController(rootViewController: bookVC)
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [booksNav, bookNav]
            booksVC.delegate = bookVC
            
            mainViewController = splitVC
        } else {
            mainViewController = booksNav
        }

        window = UIWindow(frame: UIScreen.main.bounds)

        // if it is the first time that the app is running then
        // the JSON file needs to be downloaded
        if !UserDefaults.standard.bool(forKey: appInitializedKey) {
            
            // Show loading information ViewController while JSON is being processed
            let loadingVC = LoadingDataViewController(nextViewController: mainViewController)
            self.window?.rootViewController = loadingVC
            
            // Listening for ContextDidSave notifications
            NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
            
            // Processing JSON file in background
            model.performBackgroundBatchOperation(loadInitialData)
        } else {
            self.model.autoSave(autoSaveInterval)
            self.window?.rootViewController = mainViewController
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func loadInitialData(_ workerContext: NSManagedObjectContext) -> () {
        do {
            // Get JSON file with books data from remote
            let jsonArray = try DataDownloader.sharedInstance.downloadApplicationData()
            
            // Proccess each JSON object inside the array
            for dict:JSONDictionary in jsonArray {
                
                // if the format of the JSON object is correct a new book is created
                if let title = dict["title"] as? String,
                    let tagsString = dict["tags"] as? String,
                    let authorsString = dict["authors"] as? String,
                    let imageURL = dict["image_url"] as? String,
                    let docURL = dict["pdf_url"] as? String {
                    
                    // Converts authos and tags strings to arrays
                    let authors = authorsString.components(separatedBy: ", ")
                    let tags = tagsString.components(separatedBy: ", ")
                    
                    // Creating new book
                    let cover = Cover(imageURL: imageURL, inContext: workerContext)
                    let pdf = Document(documentURL: docURL, inContext: workerContext)
                    let _ = Book(title: title, authors: authors, tags: tags, cover: cover, document: pdf, inContext: workerContext)
                }
            }
            
            // Setting app as initialized in UserDefaults
            UserDefaults.standard.set(true, forKey: appInitializedKey)
        } catch ApplicationErrors.invalidJSONURL {
            print("ERROR: Invalid JSON URL")
        } catch ApplicationErrors.wrongJSONData {
            print("ERROR: Invalid JSON data")
        } catch ApplicationErrors.unrecognizedJSONData {
            print("ERROR: Unrecognized JSON data")
        } catch {
            print("ERROR: Unknown error")
        }
    }
    
    func contextDidSave(notification: NSNotification) {
        
        // Unsubscribing from NSManagedObjectContextDidSave notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        
        self.model.autoSave(autoSaveInterval)
        
        // Displaying rootViewController
        let windowVC = self.window?.rootViewController as! LoadingDataViewController
        windowVC.presentRootViewController()
    }
}

