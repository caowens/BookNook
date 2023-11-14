//
//  ViewController.swift
//  BookNook
//
//  Created by Alex Owens on 11/7/23.
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows for the table
        return books.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: - Pass the selected book data

        // Get the index path for the selected row.
        // `indexPathForSelectedRow` returns an optional `indexPath`, so we'll unwrap it with a guard.
        guard let selectedIndexPath = homeTableView.indexPathForSelectedRow else { return }

        // Get the selected book from the movies array using the selected index path's row
        let selectedBook = books[selectedIndexPath.row]

        // Get access to the detail view controller via the segue's destination. (guard to unwrap the optional)
        guard let detailViewController = segue.destination as? DetailViewController else { return }

        detailViewController.book = selectedBook
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create, configure, and return a table view cell for the given row (i.e., `indexPath.row`)

        // Get a reusable cell
        // Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table. This helps optimize table view performance as the app only needs to create enough cells to fill the screen and reuse cells that scroll off the screen instead of creating new ones.
        // The identifier references the identifier you set for the cell previously in the storyboard.
        // The `dequeueReusableCell` method returns a regular `UITableViewCell`, so we must cast it as our custom cell (i.e., `as! BookCell`) to access the custom properties you added to the cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell

        // Get the book-associated table view row
        let book = books[indexPath.row]

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
    

    @IBOutlet weak var homeTableView: UITableView!
    
    // A property to store the books we fetch.
    // Providing a default value of an empty array (i.e., `[]`) avoids having to deal with optionals.
    private var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchBooks()
    }
    
    // Customary to call the overridden method on `super` any time you override a method.
    override func viewWillAppear(_ animated: Bool) {
        // get the index path for the selected row
        if let selectedIndexPath = homeTableView.indexPathForSelectedRow {

            // Deselect the currently selected row
            homeTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    // Fetches a list of embeddable books from the Google Books API
    private func fetchBooks() {
        
        let apiKey = ProcessInfo.processInfo.environment["BOOKS_API_KEY"] ?? "No API key found at that string"

        let url = URL(string: "https://www.googleapis.com/books/v1/users/103916951314575156787/bookshelves/0/volumes?key=\(apiKey)")!
        // ---
        // Create the URL Session to execute a network request given the above url in order to fetch our book data.
        // https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
        // ---
        let session = URLSession.shared.dataTask(with: url) { data, response, error in

            // Check for errors
            if let error = error {
                print("🚨 Request failed: \(error.localizedDescription)")
                return
            }

            // Check for server errors
            // Make sure the response is within the `200-299` range (the standard range for a successful response).
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("🚨 Server Error: response: \(String(describing: response))")
                return
            }

            // Check for data
            guard let data = data else {
                print("🚨 No data returned from request")
                return
            }

            // The JSONDecoder's decode function can throw an error. To handle any errors we can wrap it in a `do catch` block.
            do {

                // Decode the JSON data into our custom `BookResponse` model.
                let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)

                // Access the array of books
                let books = bookResponse.items

                // Run any code that will update UI on the main thread.
                DispatchQueue.main.async { [weak self] in

                    // We have books! Do something with them!
                    print("✅ SUCCESS!!! Fetched \(books.count) books")

                    // Iterate over all books and print out their details.
                    for book in books {
                        print("🍿 Book ------------------")
                        print("Title: \(book.volumeInfo.title)")
                        print("Description: \(book.volumeInfo.description)")
                    }

                    // Update the books property so we can access book data anywhere in the view controller.
                    self?.books = books
                    self?.homeTableView.reloadData()
                    print("🍏 Fetched and stored \(books.count) books")



                }
            } catch {
                print("🚨 Error decoding JSON data into Book Response: \(error.localizedDescription)")
                return
            }
        }

        // Don't forget to run the session!
        session.resume()
    }


}

