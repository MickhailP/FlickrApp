//
//  ImageDetailView.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 30.11.2022.
//

import SwiftUI

struct ImageDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let image: UIImage?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(5)
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding()
                
            }
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(image: UIImage(systemName: "world"))
    }
}
