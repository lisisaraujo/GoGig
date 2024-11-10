//
//  SelectLocationView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 07.11.24.
//

import SwiftUI
import CoreLocation
import GooglePlaces

struct SelectLocationView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    @Binding  var isAutocompletePresented: Bool
    
    var body: some View {
        HStack{
            Button(action: {
                isAutocompletePresented.toggle()
            }) {
                Text("Select Location")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .sheet(isPresented: $isAutocompletePresented) {
                AutocompleteControllerView(location: $postsViewModel.selectedLocation, selectedCoordinates: $postsViewModel.selectedCoordinates)
            }
            
            if !postsViewModel.selectedLocation.isEmpty {
                Text("Selected Location: \(postsViewModel.selectedLocation)")
                if let coordinate = postsViewModel.selectedCoordinates {
                    Text("Coordinates: \(coordinate.latitude), \(coordinate.longitude)")
                }
            }
        }
    }
}

#Preview {
    SelectLocationView(
        isAutocompletePresented: .constant(false)
    )
}
