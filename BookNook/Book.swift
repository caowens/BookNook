//
//  Book.swift
//  BookNook
//
//  Created by Alex Owens on 11/13/23.
//

import Foundation

struct BookResponse: Decodable {
    let items: [Book]
}

struct Book: Codable, Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return
            lhs.volumeInfo.title == rhs.volumeInfo.title
    }
    
    let volumeInfo: VolumeInfo
}

extension Book {
    // The "Collection" key: a computed property that returns a String.
    //    - Use when saving/retrieving or removing from UserDefaults
    //    - `static` means this property is "Type Property" (i.e. associated with the Book "type", not any particular book instance)
    //    - We can access this property anywhere like this... `Book.collectionKey` (i.e. Type.property)
    static var collectionKey: String {
        return "Collection"
    }

    // Save an array of books you want to read to UserDefaults.
    //    - Similar to the collectionKey, we add the `static` keyword to make this a "Type Method".
    //    - We can call it from anywhere by calling it on the `Book` type.
    //    - ex: `Book.save(collectedBooks, forKey: collectionKey)`
    // 1. Create an instance of UserDefaults
    // 2. Try to encode the array of `Book` objects to `Data`
    // 3. Save the encoded book `Data` to UserDefaults
    static func save(_ books: [Book], forKey key: String) {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        let encodedData = try! JSONEncoder().encode(books)
        // 3.
        defaults.set(encodedData, forKey: key)
    }

    // Get the array of collected books from UserDefaults
    //    - Again, a static "Type method" we can call anywhere like this...`Book.getBooks(forKey: collectionKey)`
    // 1. Create an instance of UserDefaults
    // 2. Get any collected books `Data` saved to UserDefaults (if any exist)
    // 3. Try to decode the book `Data` to `Book` objects
    // 4. If 2-3 are successful, return the array of books
    // 5. Otherwise, return an empty array
    static func getBooks(forKey key: String) -> [Book] {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        if let data = defaults.data(forKey: key) {
            // 3.
            let decodedBooks = try! JSONDecoder().decode([Book].self, from: data)
            // 4.
            return decodedBooks
        } else {
            // 5.
            return []
        }
    }
    
    // Adds the book to the collection array in UserDefaults.
    // 1. Get all collected books from UserDefaults
    //    - We make `collectedBooks` a `var` so we'll be able to modify it when adding another book
    // 2. Add the book to the collected books array
    //   - Since this method is available on "instances" of a book, we can reference the book this method is being called on using `self`.
    // 3. Save the updated collected books array
    func addToCollection() {
        // 1.
        var collectedBooks = Book.getBooks(forKey: Book.collectionKey)
        // 2.
        collectedBooks.append(self)
        // 3.
        Book.save(collectedBooks, forKey: Book.collectionKey)
    }

    // Removes the book from the collections array in UserDefaults
    // 1. Get all collected books from UserDefaults
    // 2. remove all books from the array that match the book instance this method is being called on (i.e. `self`)
    //   - The `removeAll` method iterates through each book in the array and passes the book into a closure where it can be used to determine if it should be removed from the array.
    // 3. If a given book passed into the closure is equal to `self` (i.e. the book calling the method) we want to remove it. Returning a `Bool` of `true` removes the given book.
    // 4. Save the updated collected books array.
    func removeFromCollection() {
        // 1.
        var collectedBooks = Book.getBooks(forKey: Book.collectionKey)
        // 2.
        collectedBooks.removeAll { book in
            // 3.
            return self == book
        }
        // 4.
        Book.save(collectedBooks, forKey: Book.collectionKey)
    }
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let publishedDate: String
    let description: String
    let pageCount: Int
    let imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    let smallThumbnail: URL?
    let thumbnail: URL?
}
