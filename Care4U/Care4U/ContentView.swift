//
//  ContentView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
            HomeView()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
