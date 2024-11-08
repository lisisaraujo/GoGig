//
//  LocationPickerView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 08.11.24.
//

import SwiftUI
import CoreLocation

struct LocationPickerView: View {
    @Binding var selectedLocation: String?
    @Binding var selectedCoordinates: CLLocationCoordinate2D?
    @Binding var selectedDistance: Double
    @State private var tempLocation = ""
    @State private var tempCoordinates: CLLocationCoordinate2D?
    @State private var showAutocomplete = false
    @EnvironmentObject var postsViewModel: PostsViewModel
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter location", text: $tempLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onTapGesture {
                        showAutocomplete = true
                    }
                
                Text("Search Radius: \(Int(selectedDistance)) km")
                Slider(value: $selectedDistance, in: 0...1000, step: 1)
                    .padding()
                
                Button("Apply") {
                    selectedLocation = tempLocation
                    selectedCoordinates = tempCoordinates
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Show Posts Worldwide") {
                    selectedLocation = "Worldwide"
                    selectedCoordinates = nil
                    selectedDistance = 0
                    tempLocation = ""
                    tempCoordinates = nil
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
                AutocompleteControllerView(location: $tempLocation, selectedCoordinates: $tempCoordinates)
            }
        }
    }
}

#Preview {
    LocationPickerView(
        selectedLocation: .constant("Berlin"),
        selectedCoordinates: .constant(CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)),
        selectedDistance: .constant(100.0)
    )
    .environmentObject(PostsViewModel())
    .environmentObject(AuthViewModel())
}

