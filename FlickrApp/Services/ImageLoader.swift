//
//  ImageLoader.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation
import UIKit

class ImageLoader: ObservableObject {
    
    let urlString: String
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = true
    
    let networkingService: NetworkingProtocol
    
    init(urlString: String, networkingService: NetworkingProtocol) {
        self.urlString = urlString
        self.networkingService = networkingService
        downloadImage()
    }
    
    func downloadImage() {
        
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let imageData = try await networkingService.downloadData(from: url)
                
                await MainActor.run(body: {
                    image = UIImage(data: imageData)
                })
                
            } catch {
                isLoading = false
                print("Error occurs during downloading Image")
            }
        }
    }
}
