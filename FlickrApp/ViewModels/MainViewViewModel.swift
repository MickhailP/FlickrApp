//
//  MainViewViewModel.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation

class MainViewViewModel: ObservableObject {
    
    @Published var dataArray: [ImageModel] = []
    @Published var showErrorMessage: Bool = false
    
    @Published var searchTag: String = ""
    
    
    let networkingService: NetworkingProtocol
    
    init(networkingService: NetworkingProtocol) {
        self.networkingService = networkingService
    }
    
    func searchImages(for tags: String) {
        if let url = networkingService.createURL(for: tags) {
            Task {
                await fetchData(from: url)
            }
        }
    }
    
    private func fetchData(from url: URL) async {
        
        do {
            let fetchedData = try await networkingService.downloadData(from: url)
            
            let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: fetchedData)
            
            await MainActor.run(body: {
                dataArray = decodedResponse.items

            })
            
        } catch  {
            showErrorMessage = true
            print("Error occurred during fetching data")
        }
       
    }
}
