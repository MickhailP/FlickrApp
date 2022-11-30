//
//  ContentView.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: MainViewViewModel
    
    init(networkingService: NetworkingProtocol) {
        
       _viewModel = StateObject(wrappedValue: MainViewViewModel(networkingService: networkingService))
    }
    
    var body: some View {
        VStack {
                
            searchBar()
                .padding()
            
            if !viewModel.sortedData.isEmpty {
                ScrollView{
                    ForEach(viewModel.sortedData, id: \.self) { item in
                        ImageRowView(model: item, networkingService: viewModel.networkingService)
                    }
                }
            } else {
                //Empty view
                emptyView
                
            }
        }
        .alert(isPresented: $viewModel.showErrorMessage) {
            Alert(title: Text("Oops!"), message: Text("Error occurred during data fetching.\n Try again."))
        }
        
    }
}


extension MainView {
    
    ///  Creates a search bar for the MainView
    /// - Returns: search bar section View
    private func searchBar() -> some View {
        HStack{
            // Search Text field for creating a Request
            TextField("Search", text: $viewModel.searchTag)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    viewModel.searchImages(for: viewModel.searchTag)
                }
            
            //Search button
            Button {
                viewModel.searchImages(for: viewModel.searchTag)
            } label: {
                Image(systemName: "magnifyingglass")
            }
            
            //Sorting options button
            Menu {
                Button {
                    viewModel.sorter = .byName
                } label: {
                    Label("Sort by name", systemImage: "textformat.alt")
                }
                Button {
                    viewModel.sorter = .byNewest
                } label: {
                    Label("Newest", systemImage: "arrow.up")
                }
                Button {
                    viewModel.sorter = .byOldest
                } label: {
                    Label("Oldest", systemImage: "arrow.down")
                }
                
                
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
        }
    }
    
    var emptyView: some View {
        VStack {
            Spacer()
            VStack(spacing: 10){
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 50))
                Text("List is empty. Try to find something!")
                
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(networkingService: Networking())
    }
}
