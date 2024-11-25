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
                LocationSelectionView(showAutocomplete: $showAutocomplete)
                
                SearchRadiusView(selectedDistance: $postsViewModel.selectedDistance)
                
                ActionButtonsView(dismiss: dismiss)
            }
            .padding()
        }
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

struct LocationSelectionView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Binding var showAutocomplete: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
                .font(.headline)
            
            Button(action: {
                showAutocomplete = true
            }) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    Text(postsViewModel.selectedLocation.isEmpty ? "Enter location" : postsViewModel.selectedLocation)
                        .foregroundColor(postsViewModel.selectedLocation.isEmpty ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

struct SearchRadiusView: View {
    @Binding var selectedDistance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search Radius")
                .font(.headline)
            
            Text("\(Int(selectedDistance)) km")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Slider(value: $selectedDistance, in: 0...1000, step: 1)
                .accentColor(.blue)
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
