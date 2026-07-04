//
//  ContentView.swift
//  EasyDelivery
//
//  Created by Sameer Eismati on 7/1/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var auth: AuthViewModel

    var body: some View {
        if auth.isLoggedIn {
            ProductListView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CartViewModel())
        .environmentObject(AuthViewModel())
}
