import UIKit

// Custom Cell View to display books information in LibraryViewController

class BookViewCell: UITableViewCell {

    static let cellId: String = "CustomBookCell"
    static let cellHeight: CGFloat = 65
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    private var _bookObserver : NSObjectProtocol?
    
    var book: Book? {
        didSet {
            startObserving()
            fillCell()
        }
    }
    
    func fillCell() {
        if let book = book {
            bookName.text = book.title
            bookAuthors.text = book.authorNames()
            bookImage.image = book.cover?.image
        }
    }
    
    func startObserving(){
        let name = NSNotification.Name(rawValue: Book.bookCoverChangedEvent)
        _bookObserver = NotificationCenter.default.addObserver(forName: name, object: book, queue: nil) { (n: Notification) in
            self.fillCell()
        }
    }
    
    func stopObserving(){
        if let observer = _bookObserver {
            NotificationCenter.default.removeObserver(observer)
            _bookObserver = nil
            book = nil
        }
    }
    
    // Sets the view in a neutral state, before being reused
    override func prepareForReuse() {
        stopObserving()
        fillCell()
    }
    
    deinit {
        stopObserving()
    }
}
