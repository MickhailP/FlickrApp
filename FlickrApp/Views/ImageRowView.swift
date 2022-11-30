//
//  ImageRowView.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 30.11.2022.
//

import SwiftUI



struct ImageRowView: View {
    
    @StateObject var viewModel: ImageRowViewModel

    init(model: ImageModel, networkingService: NetworkingProtocol) {
        _viewModel = StateObject(wrappedValue: ImageRowViewModel(model: model, networkingService: networkingService))
    }
    
    var body: some View {
        HStack {
            
            ImagePreview(loader: viewModel)
            
            imageInfoSection
        }
        .onTapGesture {
            viewModel.showImageFullScreen = true
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fullScreenCover(isPresented: $viewModel.showImageFullScreen) {
            ImageDetailView(image: viewModel.image)
        }
    }
}

extension ImageRowView {
    var imageInfoSection: some View {
        VStack(alignment: .leading) {
            Text(viewModel.model.title)
                .font(.title3)
            Text("Author: \(viewModel.model.author)")
        
            Text("Published: \(viewModel.model.dateTaken)")
                .font(.caption)
                
            Text("Tags: " + "\(viewModel.model.tags.isEmpty ? "no tags" : viewModel.model.tags)")
                .font(.caption2)
        }
    }
}

struct ImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageRowView(
            model: ImageModel.example, networkingService: Networking()
        )
    }
}
