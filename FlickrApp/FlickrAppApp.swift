//
//  FlickrAppApp.swift
//  FlickrApp
//
//  Created by Миша Перевозчиков on 29.11.2022.
//

import SwiftUI

@main
struct FlickrAppApp: App {
    let networkingService = Networking()
    
    var body: some Scene {
        WindowGroup {
            MainView(networkingService: networkingService)
        }
    }
}
