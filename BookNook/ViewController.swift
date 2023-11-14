//
//  ViewController.swift
//  BookNook
//
//  Created by Alex Owens on 11/7/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        
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
        
//        print(whatever)
//        print(ProcessInfo.processInfo.environment["BOOKS_API_KEY"] ?? "No API key found at that string")
        
        fetchBooks()
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

