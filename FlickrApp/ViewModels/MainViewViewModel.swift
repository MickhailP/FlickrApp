//
//  MainViewViewModel.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import Foundation
import Combine


class MainViewViewModel: ObservableObject {
    
    // MARK: Data Arrays
    @Published private var dataArray: [ImageModel] = []
    
    // Use this instance to get access to sorted dataArray of ImageModel's
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
    
    //Alert tracker
    @Published var showErrorMessage: Bool = false
    
    //Searching text
    @Published var searchTag: String = ""
    
    // MARK: Sorter enum
    @Published var sorter: SortType = .none
    enum SortType {
        case none, byName, byNewest, byOldest
    }
    
    // MARK: Networking layer
    let networkingService: NetworkingProtocol
    
    var cancellables = Set<AnyCancellable>()

    
    // MARK: Init
    init(networkingService: NetworkingProtocol) {
        self.networkingService = networkingService
        addTextfieldSubscriber()
    }
    
    
    
    // MARK: Data fetching methods
    func searchImages(for tags: String) {
        if let url = networkingService.createURL(for: tags) {
            Task {
                await fetchData(from: url)
            }
        }
    }
    
    /// Create an asynchronous request for data through Networking service and decode received  data.
    ///
    /// If  fetching or decoding data has been failed, it will throw an error and show alert to user.
    /// - Parameter url: URL request to API
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
    
    // MARK: Subscriber
    //
    /// Subscribes on Textfield $searchTag and start searching images if count of characters >= 2 . Use 
    func addTextfieldSubscriber() {
        $searchTag
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .map({ (text) -> Bool in
                if text.count >= 2 {
                    return true
                }
                return false
            })
            .sink { [weak self] isValid in
                guard let self = self else { return }
                
                if isValid {
                    self.searchImages(for: self.searchTag)
                }
            }
            .store(in: &cancellables)

    }
    
    // MARK: Sorting methods
    /// Compare two titles in ImageModel to sort them. This will help .sorted(by:   ) create an Alphabetical order.
    /// - Parameters:
    ///   - lhs: first title
    ///   - rhs: second title
    /// - Returns: Result of comparing two titles.
    private func sortByName(_ lhs: ImageModel, _ rhs: ImageModel) -> Bool {
        lhs.title < rhs.title
    }
    
    /// Compare two dates in ImageModel to sort them. This will help .sorted(by:   ) create an order where Newest items will be in the beginning.
    /// - Parameters:
    ///   - lhs: first date
    ///   - rhs: second date
    /// - Returns: Result of comparing two dates
    private func sortByNewest(_ lhs: ImageModel, _ rhs: ImageModel) -> Bool {
        lhs.dateTaken > rhs.dateTaken
    }
    /// Compare two dates in ImageModel to sort them. This will help .sorted(by:   ) create an order where Oldest items will be in the beginning.
    /// - Parameters:
    ///   - lhs: first date
    ///   - rhs: second date
    /// - Returns: Result of comparing two dates
    private func sortByOldest(_ lhs: ImageModel, _ rhs: ImageModel) -> Bool {
        lhs.dateTaken < rhs.dateTaken
    }
    
}
