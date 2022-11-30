//
//  ImagePreview.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 30.11.2022.
//

import SwiftUI

struct ImagePreview: View {
    
    @ObservedObject var loader: ImageRowViewModel
    
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            }
        }
        .frame(width: 75, height: 75)
    }
}

struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreview(loader: ImageRowViewModel(model: ImageModel.example, networkingService: Networking()))
    }
}
