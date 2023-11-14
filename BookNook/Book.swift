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

struct Book: Decodable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]
    let publishedDate: String
    let description: String
    let pageCount: Int
    let imageLinks: ImageLinks
}

struct ImageLinks: Decodable {
    let smallThumbnail: URL?
    let thumbnail: URL?
}
