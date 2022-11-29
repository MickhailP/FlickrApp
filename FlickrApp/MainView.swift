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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
