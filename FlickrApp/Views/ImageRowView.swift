//
//  ImageRowView.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 30.11.2022.
//

import SwiftUI



struct ImageRowView: View {
    
    @StateObject var viewModel: ImageRowViewModel

    init(model: ImageModel) {
        _viewModel = StateObject(wrappedValue: ImageRowViewModel(model: model, networkingService: Networking()))
    }
    
    var body: some View {
        HStack {
            
            ImagePreview(loader: viewModel)
            
            VStack(alignment: .leading) {
                Text(viewModel.model.title)
                    .font(.title3)
                Text("Author: \(viewModel.model.author)")
            
                Text("Published: \(viewModel.model.published)")
                    .font(.caption)
                    
                Text("Tags: " + "\(viewModel.model.tags.isEmpty ? "no tags" : viewModel.model.tags)")
                    .font(.caption2)
            }
        }
        .onTapGesture {
            viewModel.showImageFullScreen = true
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $viewModel.showImageFullScreen) {
            ImageDetailView(image: viewModel.image)
        }
    }
}

struct ImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageRowView(
            model: ImageModel.example
        )
    }
}
