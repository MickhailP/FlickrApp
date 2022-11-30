//
//  ImageLoader.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation
import UIKit

class ImageRowViewModel: ObservableObject {
    
    let model: ImageModel
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = true
    
    @Published var showImageFullScreen: Bool = false
    
    let networkingService: NetworkingProtocol
    
    init(model: ImageModel, networkingService: NetworkingProtocol) {
        self.model = model
        self.networkingService = networkingService
        downloadImage()
    }
    
    /// Download Image data from URL from ImageModel.link
    ///
    /// Creates a URL request through Networking service, then creates an UIImage from received data.
    private func downloadImage() {
        
        guard let url = URL(string: model.media.urlString) else {
            isLoading = false
            return
        }
        
        Task {
            do {
                let imageData = try await networkingService.downloadData(from: url)
                
                await MainActor.run(body: {
                    image = UIImage(data: imageData)
                    isLoading = false
                })
                
            } catch {
                isLoading = false
                print("Error occurs during downloading Image")
            }
        }
    }
}
