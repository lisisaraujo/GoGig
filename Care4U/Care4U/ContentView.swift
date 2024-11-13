//
//  ContentView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 28.10.24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var postsViewModel = PostsViewModel()
    @StateObject var serviceRequestViewModel = ServiceRequestViewModel()
    @StateObject var inboxViewModel = InboxViewModel()

    
    
    var body: some View {
        HomeView()
            .onAppear {
                updateLocationAndCoordinates()
            }
            .onChange(of: authViewModel.isUserLoggedIn) { _,_ in
                updateLocationAndCoordinates()
            }
            .environmentObject(postsViewModel)
            .environmentObject(authViewModel)
            .environmentObject(serviceRequestViewModel)
            .environmentObject(inboxViewModel)
    }
    
    func updateLocationAndCoordinates() {
        if let user = authViewModel.currentUser {
            postsViewModel.selectedLocation = user.location
            postsViewModel.selectedCoordinates = CLLocationCoordinate2D(latitude: user.latitude ?? 0.0, longitude: user.longitude ?? 0.0)
            postsViewModel.isWorldwideMode = false
        } else {
            postsViewModel.selectedLocation = "Worldwide"
            postsViewModel.selectedCoordinates = nil
            postsViewModel.isWorldwideMode = true
        }
    }
    
}


#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(PostsViewModel())
        .environmentObject(ServiceRequestViewModel())
        .environmentObject(InboxViewModel())
}
