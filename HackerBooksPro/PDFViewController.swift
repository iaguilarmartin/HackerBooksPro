import UIKit

// View Controller to display PDF files
class PDFViewController: UIViewController {
    
    //MARK: - Properties
    var model: Book
    
    //MARK: - IBOutlets
    @IBOutlet weak var pdfWebView: UIWebView!
    
    //MARK: - Initializers
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension PDFViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To display navigation bar without transparency
        self.edgesForExtendedLayout = UIRectEdge()
        
        // Adding show annotations button
        let annoButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showAnnotations))
        self.navigationItem.rightBarButtonItem = annoButton
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to selectedBookChanged notifications
        NotificationCenter.default.addObserver(self, selector: #selector(newBookSelected), name: NSNotification.Name(rawValue: BooksViewController.selectedBookChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(documentLoaded), name: NSNotification.Name(rawValue: Book.bookDocumentChangedEvent), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to all notifications
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Functions
extension PDFViewController {
    
    // function to update controller title and WebView content
    func updateView() {
        self.title = self.model.title
        
        pdfWebView.load((model.document?.data)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"http://www.google.com")!)
        
        // Saving in UserDefaults last readed book
        let uri = self.model.objectID.uriRepresentation()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: uri), forKey: Book.lastReadedBookKey)
    }
    
    // Function called when selectedBookChanged notification arrives
    func newBookSelected(_ notificarion: Notification) {
        let info = (notificarion as NSNotification).userInfo
        
        if let book = info?[BooksViewController.selectedBookKey] as? Book {
            self.model = book
            updateView()
        }
        
    }
    
    func documentLoaded(_ notificarion: Notification) {
        updateView()
    }
    
    // Function for navigating to AnnotationsViewController
    func showAnnotations() {
        let annotationsVC = AnnotationsViewController(book: self.model)
        navigationController?.pushViewController(annotationsVC, animated: true)
    }

}
