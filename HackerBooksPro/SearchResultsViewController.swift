import UIKit

// View Controller to display books matching search filter
class SearchResultsViewController: UITableViewController {

    var filteredBooks = [Book]()
}

//MARK: - Lifecycle
extension SearchResultsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registering custom cell Nib
        let nib = UINib(nibName: "BookViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookViewCell.cellId)
    }
}

// MARK: - Table view data source
extension SearchResultsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book = filteredBooks[indexPath.row]
        
        // Try to reuse an existing cell
        let cell: BookViewCell? = tableView.dequeueReusableCell(withIdentifier: BookViewCell.cellId, for: indexPath) as? BookViewCell
        
        // Set book to be displayed
        cell?.book = book
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookViewCell.cellHeight
    }

}
