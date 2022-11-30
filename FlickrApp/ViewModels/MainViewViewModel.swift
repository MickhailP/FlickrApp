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
    
    @Published private var sorter: SortType = .none
    
    enum SortType {
        case none, byName, byDate
    }
    
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
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let decodedResponse = try decoder.decode(APIResponse.self, from: fetchedData)
           
            await MainActor.run(body: {
                dataArray = decodedResponse.items

            })
            
        } catch  {
            await MainActor.run(body: {
                showErrorMessage = true
                print(error)
                print("Error occurred during fetching data", error.localizedDescription)
            })
        }
       
    }
}
