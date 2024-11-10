//
//  LocationPickerView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 08.11.24.
//

import SwiftUI
import CoreLocation

struct LocationPickerView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showAutocomplete = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter location", text: $postsViewModel.selectedLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onTapGesture {
                        showAutocomplete = true
                    }
                
                Text("Search Radius: \(Int(postsViewModel.selectedDistance)) km")
                Slider(value: $postsViewModel.selectedDistance, in: 0...1000, step: 1)
                    .padding()
                
                Button("Apply") {
                    postsViewModel.filterPosts(selectedPostType: nil, searchText: nil, maxDistance: postsViewModel.selectedDistance)
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Show Posts Worldwide") {
                    postsViewModel.resetFilters()
                    dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Location")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .sheet(isPresented: $showAutocomplete) {
                AutocompleteControllerView(
                    location: $postsViewModel.selectedLocation,
                    selectedCoordinates: Binding(
                        get: { postsViewModel.selectedCoordinates ?? CLLocationCoordinate2D() },
                        set: { postsViewModel.selectedCoordinates = $0 }
                    )
                )
            }
        }
    }
}

#Preview {
    LocationPickerView()
        .environmentObject(PostsViewModel())
        .environmentObject(AuthViewModel())
}
