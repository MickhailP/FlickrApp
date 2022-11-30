//
//  ContentView.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: MainViewViewModel
    
    init() {
        let networkingService = Networking()
       _viewModel = StateObject(wrappedValue: MainViewViewModel(networkingService: networkingService))
    }
    
    var body: some View {
        VStack {
                
            searchBar()
                .padding()
            
            ScrollView{
                ForEach(viewModel.dataArray, id: \.self) { item in
                    ImageRowView(model: item)
                }
            }
        }
        
    }
}


extension MainView {
    
    private func searchBar() -> some View {
        HStack{
            TextField("Search", text: $viewModel.searchTag)
                .textFieldStyle(.roundedBorder)
            
            Button {
                viewModel.searchImages(for: viewModel.searchTag)
            } label: {
                Image(systemName: "magnifyingglass")
            }
            
            Button {
                
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
            
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
