////
////  PlacesManager.swift
////  Care4U
////
////  Created by Lisis Ruschel on 04.11.24.
////
//
//import GooglePlaces
//import CoreLocation
//
//class PlacesManager: ObservableObject {
//    private var placesClient: GMSPlacesClient!
//    @Published var predictions: [GMSAutocompletePrediction] = []
//    
//    init() {
//        placesClient = GMSPlacesClient.shared()
//    }
//    
//    func findPlaces(query: String) {
//        let filter = GMSAutocompleteFilter()
//        filter.type = .geocode
//        
//        placesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { [weak self] (results, error) in
//            if let error = error {
//                print("Error fetching autocomplete predictions: \(error.localizedDescription)")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self?.predictions = results ?? []
//            }
//        }
//    }
//
//    
//    func getCoordinates(for placeID: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
//        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: [.coordinate], sessionToken: nil) { (place, error) in
//            if let error = error {
//                print("Error fetching place details: \(error.localizedDescription)")
//                completion(nil)
//            }
//            
//            if let place = place {
//                completion(place.coordinate)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//}
