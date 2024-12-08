//
//  AutocompleteControllerView.swift
//  Care4U
//
//  Created by Lisis Ruschel on 04.11.24.
//

import SwiftUI
import GooglePlaces

struct AutocompleteControllerView: UIViewControllerRepresentable {
    @Binding var location: String
    @Binding var selectedCoordinates: CLLocationCoordinate2D?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        var parent: AutocompleteControllerView

        init(parent: AutocompleteControllerView) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            parent.location = place.name ?? "Unknown"
            parent.selectedCoordinates = place.coordinate
            parent.presentationMode.wrappedValue.dismiss()
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
            parent.presentationMode.wrappedValue.dismiss()
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator

        let fields: GMSPlaceField = [.name, .placeID, .coordinate]
        autocompleteController.placeFields = fields

        let filter = GMSAutocompleteFilter()
        filter.types = ["locality", "country"]
        autocompleteController.autocompleteFilter = filter

        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {}
}
