//
//  DetailViewController.swift
//  BookNook
//
//  Created by Alex Owens on 11/13/23.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var shelveButton: UIButton!
    @IBAction func didTapShelveButton(_ sender: UIButton) {
        // Set the button's isSelected state to the opposite of it's current value.
        sender.isSelected = !sender.isSelected
        
        // 1. If the button is in the *selected* state (i.e. "favorited") -> Add book to favorites
        // 2. Otherwise, the button is in the *un-selected* state (i.e."un-favorited") -> Remove book from collection
        if sender.isSelected {
            // 1.
            book.addToCollection()
        } else {
            // 2.
            book.removeFromCollection()
        }
    }
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the button's corner radius to be 1/2  it's width. This will make a square button round.
        shelveButton.layer.cornerRadius = shelveButton.frame.width / 2
        
        titleLabel.text = book.volumeInfo.title
        descriptionLabel.text = book.volumeInfo.description
        navigationItem.largeTitleDisplayMode = .never
        
        // Turn the array of authors into a single string
        let authorsString = book.volumeInfo.authors.joined(separator: ", ")
        authorsLabel.text = "Author(s): \(authorsString)"
        
        publishedDateLabel.text = "Published Date: \(book.volumeInfo.publishedDate)"
        pageCountLabel.text = "Page Count: \(book.volumeInfo.pageCount)"
        
        // Unwrap the optional cover path
        if let coverPath = book.volumeInfo.imageLinks.thumbnail {

           let imageUrl = coverPath

            // Use the Nuke library's load image function to (async) fetch and load the image from the image URL.
            Nuke.loadImage(with: imageUrl, into: coverImageView)
        }
        
        // Update the button's selected state based on the current book's collected status.
        // 1. Get the array of collected books.
        // 2. Check if the collected books array contains the current book.
        // 3. If so, the book has been collected -> Set the button to the *selected* state.
        // 4. Otherwise, the book is not-collected -> Set the button to the *un-selected* state.
        // ------

        // 1.
        let collected = Book.getBooks(forKey: Book.collectionKey)
        // 2.
        if collected.contains(book) {
            // 3.
            shelveButton.isSelected = true
        } else {
            // 4.
            shelveButton.isSelected = false
        }
        
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
