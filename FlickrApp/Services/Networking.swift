//
//  Networking.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation

protocol NetworkingProtocol {
    
    func createURL(for tags: String) -> URL?
    func downloadData(from url: URL) async throws -> Data
}

final class Networking: NetworkingProtocol {
    
    func createURL(for tags: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.flickr.com"
        urlComponents.path = "/services/feeds/photos_public.gne"
        
        let tagsQuery = tags.lowercased().components(separatedBy: " ")
        let joined = tagsQuery.joined(separator: ",")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "tags", value: joined),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        
        guard let url = urlComponents.url else {
            print("Failed to construct URL")
            return nil
        }
        
        print("The URL is: ", url)
        return url
    }
    
    func downloadData(from url: URL) async throws -> Data {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try handleResponse(response)
            
            print(data)
            return data
        } catch  {
            print("There was an error during data fetching! ", error.localizedDescription)
            throw error
        }
    }
    
    private func handleResponse(_ response: URLResponse) throws {
        
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode <= 300
        else {
            throw URLError(.badServerResponse)
        }
    }
}
