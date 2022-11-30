//
//  ImageModel.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation

// MARK: - ImageModel

struct APIResponse: Decodable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [ImageModel]

}



    
    // MARK: - Item
    struct ImageModel: Decodable, Hashable {
        let title: String
        let link: String
        let media: Media
        let dateTaken: String
        let description: String
        let published: String
        let author, authorId, tags: String
        
        static let example = ImageModel(title: "Title",
                                        link: "https:////www.flickr.com/photos/joncutrer/52532440117/", media: Media(urlString: "test"),
                                        dateTaken: "2022-11-26T08:27:40-08:00",
                                        description: "TEST", published: "2022-11-26T08:27:40-08:00", author: "Mike", authorId: "12", tags: "")
    }
    
    // MARK: - Media
    struct Media: Decodable, Hashable {
        let urlString: String
        
        enum CodingKeys: String, CodingKey {
            case urlString = "m"
        }
        
    }

