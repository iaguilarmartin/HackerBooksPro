import UIKit

// View Controller to display detailed book information
class BookViewController: UIViewController {

    //MARK: - Properties
    var model: Book?
    
    //MARK: - IBOutlets
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    //MARK: - Initializers
    init(model: Book?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - IBActions
    @IBAction func readBook(_ sender: AnyObject) {
        
        if let book = self.model {
            let pdfVC = PDFViewController(model: book)
            self.navigationController?.pushViewController(pdfVC, animated: true)
        }
    }
    
    @IBAction func favoriteBook(_ sender: AnyObject) {
        if let book = self.model {
            book.toggleFavoriteState()
            updateView()
        }
    }
}

//MARK: - Lifecycle
extension BookViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        updateView()
        
        if self.splitViewController?.displayMode == .primaryHidden {
            self.navigationItem.rightBarButtonItem = self.splitViewController?.displayModeButtonItem
        }
    }
}

//MARK: - Functions
extension BookViewController {
    
    // Function that updates the view based on model state
    func updateView() {
        if let book = self.model {
            self.title = book.title
            self.view.isHidden = false
            
            self.titleLabel.text = book.title
            self.authorsLabel.text = book.authorNames()
            self.tagsLabel.text = book.tagNames()
            
            self.bookImage.image  = model?.cover?.image
            
            if book.isFavoriteBook() {
                favoritesButton.title = "Remove from favorites"
            } else {
                favoritesButton.title = "Add to favorites"
            }
            
        // If no model is set then main view is hidden
        } else {
            self.title = "No book selected"
            self.view.isHidden = true
        }
    }
}

//MARK: - BooksViewControllerDelegate
extension BookViewController: BooksViewControllerDelegate {
    
    func booksViewController(_ booksVC: BooksViewController, didSelectBook book: Book) {
        self.model = book
        updateView()
    }
}

//MARK: - UISplitViewControllerDelegate
extension BookViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        
        // If the screen is in portrait mode the library is displayed at the rigth
        // button of the NavigationBar
        if displayMode == .primaryHidden {
            self.navigationItem.rightBarButtonItem = self.splitViewController?.displayModeButtonItem
        } else if displayMode == .allVisible {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}
