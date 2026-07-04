//
//  ContentView.swift
//  EasyDelivery
//
//  Created by Sameer Eismati on 7/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ProductListView()
    }
}

#Preview {
    ContentView()
        .environmentObject(CartViewModel())
}
