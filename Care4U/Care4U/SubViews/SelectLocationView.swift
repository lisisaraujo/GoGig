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
    
    @Binding  var selectedLocation: String
    @Binding  var selectedCoordinate: CLLocationCoordinate2D?
    
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
                AutocompleteControllerView(location: $selectedLocation, coordinate: $selectedCoordinate)
            }
            
            if !selectedLocation.isEmpty {
                Text("Selected Location: \(selectedLocation)")
                if let coordinate = selectedCoordinate {
                    Text("Coordinates: \(coordinate.latitude), \(coordinate.longitude)")
                }
            }
        }
    }
}

#Preview {
    SelectLocationView(
        selectedLocation: .constant(""),
        selectedCoordinate: .constant(CLLocationCoordinate2D(latitude: 23.00, longitude: 20.11)),
        isAutocompletePresented: .constant(false)
    )
}
