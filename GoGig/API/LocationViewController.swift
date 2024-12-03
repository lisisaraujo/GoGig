////
////  LocationViewController.swift
////  Care4U
////
////  Created by Lisis Ruschel on 04.11.24.
////
//
//import Foundation
//import GooglePlaces
//
//class LocationViewController: UIViewController, GMSAutocompleteViewControllerDelegate {
//    
//    func presentAutocomplete() {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = [.name, .placeID, .coordinate]
//        autocompleteController.placeFields = fields
//
//        present(autocompleteController, animated: true, completion: nil)
//    }
//
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        // Get the place name and coordinates
//        let name = place.name ?? ""
//        let latitude = place.coordinate.latitude
//        let longitude = place.coordinate.longitude
//
//        print("Place name: \(name)")
//        print("Latitude: \(latitude), Longitude: \(longitude)")
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print("Error: ", error.localizedDescription)
//    }
//
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
