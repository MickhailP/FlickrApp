//
//  MainViewViewModel.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation

class MainViewViewModel: ObservableObject {
    
    @Published private var dataArray: [ImageModel] = []
    @Published private(set)var showErrorMessage: Bool = false
    
    @Published var searchTag: String = ""
    
    @Published var sorter: SortType = .none
    
    enum SortType {
        case none, byName, byNewest, byOldest
    }
    
    
    let networkingService: NetworkingProtocol
    
    //MARK: Init
    init(networkingService: NetworkingProtocol) {
        self.networkingService = networkingService
    }
    
    
    //MARK: Fetching methods
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
    
    
    //MARK: Sorting methods
    private func sortByName(_ lhs: ImageModel, _ rhs: ImageModel) -> Bool {
        lhs.title < rhs.title
    }
    private func sortByNewest(_ lhs: ImageModel, _ rhs: ImageModel) -> Bool {
        lhs.dateTaken > rhs.dateTaken
    }
    private func sortByOldest(_ lhs: ImageModel, _ rhs: ImageModel) -> Bool {
        lhs.dateTaken < rhs.dateTaken
    }
    
    //MARK: Sorted dataArray
    var sortedData: [ImageModel] {
        switch sorter {
            case .none:
                return dataArray
            case .byName:
                return dataArray.sorted(by: sortByName)
            
            case .byNewest:
                return dataArray.sorted(by: sortByNewest)
            
            case .byOldest:
                return dataArray.sorted(by: sortByOldest)
        }
    }
    
    
}
