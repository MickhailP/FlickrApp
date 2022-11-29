//
//  ImageModel.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation

// MARK: - ImageModel

struct APIResponse: Codable {
    let title: String
    let link: String
    let imageModelDescription: String
    let modified: Date
    let generator: String
    let items: [ImageModel]

}

// MARK: - Item
struct ImageModel: Codable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: Date
    let itemDescription: String
    let published: Date
    let author, authorId, tags: String

}

// MARK: - Media
struct Media: Codable {
    let m: String
}
