////
////  LocationManager.swift
////  Care4U
////
////  Created by Lisis Ruschel on 07.11.24.
////
//
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var userLocation: CLLocationCoordinate2D?
//    @Published var locationName: String?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        print("Location updated: \(location.coordinate)")
//        userLocation = location.coordinate
//        getPlaceName(for: location.coordinate)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
//
//    private func getPlaceName(for location: CLLocationCoordinate2D) {
//        let geocoder = CLGeocoder()
//        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
//
//        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Reverse geocoding error: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.locationName = nil
//                }
//                return
//            }
//
//            guard let placemark = placemarks?.first else {
//                print("No placemark found")
//                DispatchQueue.main.async {
//                    self.locationName = nil
//                }
//                return
//            }
//
//            var locationName = ""
//
//            if let locality = placemark.locality {
//                locationName += locality
//            }
//
//            if let administrativeArea = placemark.administrativeArea {
//                if !locationName.isEmpty {
//                    locationName += ", "
//                }
//                locationName += administrativeArea
//            }
//
//            if let country = placemark.country {
//                if !locationName.isEmpty {
//                    locationName += ", "
//                }
//                locationName += country
//            }
//
//            DispatchQueue.main.async {
//                self.locationName = locationName
//            }
//        }
//    }
//}
