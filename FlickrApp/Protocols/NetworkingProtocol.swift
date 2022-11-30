//
//  NetworkingProtocol.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 30.11.2022.
//

import Foundation

protocol NetworkingProtocol {
    
    func createURL(for tags: String) -> URL?
    func downloadData(from url: URL) async throws -> Data
}
