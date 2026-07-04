//
//  EasyDeliveryApp.swift
//  EasyDelivery
//
//  Created by Sameer Eismati on 7/1/26.
//

import SwiftUI

@main
struct EasyDeliveryApp: App {
    @StateObject private var cart = CartViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cart)
        }
    }
}
