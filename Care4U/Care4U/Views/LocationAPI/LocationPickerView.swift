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
    @State private var showAutocomplete = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SelectLocationView(selectedLocation:  $postsViewModel.selectedLocation, selectedCoordinates: $postsViewModel.selectedCoordinates, isAutocompletePresented: $showAutocomplete)
                
                SearchRadiusView(selectedDistance: $postsViewModel.selectedDistance)
                
                ActionButtonsView(dismiss: dismiss)
            }
            .padding()
        }.applyBackground()
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
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

struct SearchRadiusView: View {
    @Binding var selectedDistance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                Text("Search Radius")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Text("\(Int(selectedDistance)) km")
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
            }
   
            
            Slider(value: $selectedDistance, in: 0...1000, step: 1)
                .accentColor(.accent)
        }
    }
}

struct ActionButtonsView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    let dismiss: DismissAction
    
    var body: some View {
        VStack(spacing: 16) {
            PrimaryButton(title: "Apply Filters") {
                postsViewModel.filterPosts(selectedPostType: nil, searchText: nil, maxDistance: postsViewModel.selectedDistance)
                dismiss()
            }
            
            SecondaryButton(title: "Show Posts Worldwide") {
                postsViewModel.resetFilters()
                dismiss()
            }
        }
    }
}

#Preview {
    LocationPickerView()
        .environmentObject(PostsViewModel())
}
