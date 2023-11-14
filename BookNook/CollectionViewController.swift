//
//  CollectionViewController.swift
//  BookNook
//
//  Created by Alex Owens on 11/14/23.
//

import UIKit
import Nuke

class CollectionViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var collectionTableView: UITableView!
    @IBOutlet weak var emptyCollectionLabel: UILabel!
    
    var collectedBooks: [Book] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create, configure, and return a table view cell for the given row (i.e., `indexPath.row`)

        // Get a reusable cell
        // Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table. This helps optimize table view performance as the app only needs to create enough cells to fill the screen and reuse cells that scroll off the screen instead of creating new ones.
        // The identifier references the identifier you set for the cell previously in the storyboard.
        // The `dequeueReusableCell` method returns a regular `UITableViewCell`, so we must cast it as our custom cell (i.e., `as! BookCell`) to access the custom properties you added to the cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell

        // Get the book-associated table view row
        let book = collectedBooks[indexPath.row]

        // Configure the cell (i.e., update UI elements like labels, image views, etc.)

        // Unwrap the optional poster path
        if let coverPath = book.volumeInfo.imageLinks.thumbnail {

           let imageUrl = coverPath

            // Use the Nuke library's load image function to (async) fetch and load the image from the image URL.
            Nuke.loadImage(with: imageUrl, into: cell.coverImageView)
        }

        // Set the text on the labels
        cell.titleLabel.text = book.volumeInfo.title
        cell.descriptionLabel.text = book.volumeInfo.description

        // Return the cell for use in the respective table view row
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Anything in the defer call is guaranteed to happen last
        defer {
            // Show the "Empty Favorites" label if there are no favorite movies
            emptyCollectionLabel.isHidden = !collectedBooks.isEmpty
        }
        
        // TODO: Get collected books and display in table view
        // Get collected books and display in table view
        // 1. Get the array of collected books
        // 2. Set the collectedBooks property so the table view data source methods will have access to latest collected books.
        // 3. Reload the table view
        // ------

        // 1.
        let books = Book.getBooks(forKey: Book.collectionKey)
        // 2.
        self.collectedBooks = books
        // 3.
        collectionTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: - Pass the selected book data

        // Get the index path for the selected row.
        // `indexPathForSelectedRow` returns an optional `indexPath`, so we'll unwrap it with a guard.
        guard let selectedIndexPath = collectionTableView.indexPathForSelectedRow else { return }

        // Get the selected book from the movies array using the selected index path's row
        let selectedBook = collectedBooks[selectedIndexPath.row]

        // Get access to the detail view controller via the segue's destination. (guard to unwrap the optional)
//        guard let detailViewController = segue.destination as? DetailViewController else { return }
//
//        detailViewController.book = selectedBook
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
