import Foundation
import MapKit
import CoreLocation

class DinningModelView: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var restaurants: [Restaurant] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var locationAuthorizationStatus: CLAuthorizationStatus?

    private let locationManager = CLLocationManager()
    
    // Illinois State University approx location
    private let isuLocation = CLLocation(latitude: 40.5128, longitude: -88.9941)

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startSearchingNearby() {
        // Use actual user location if available, else fallback to ISU coords
        if let userLocation = locationManager.location {
            searchNearbyRestaurants(location: userLocation)
        } else {
            searchNearbyRestaurants(location: isuLocation)
        }
    }
    
    private func searchNearbyRestaurants(location: CLLocation) {
        isLoading = true
        errorMessage = nil
        restaurants = []
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Restaurant"
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 10000,    // 10 km radius for wide coverage
            longitudinalMeters: 10000
        )
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Search error: \(error.localizedDescription)"
                    return
                }
                
                guard let mapItems = response?.mapItems else {
                    self?.errorMessage = "No restaurants found nearby."
                    return
                }
                
                self?.restaurants = mapItems.map {
                    Restaurant(
                        name: $0.name ?? "Unknown",
                        address: $0.placemark.title ?? "No Address",
                        phone: $0.phoneNumber,
                        website: $0.url?.absoluteString,
                        image: nil,
                        coordinate: $0.placemark.coordinate
                    )
                }
            }
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorizationStatus = status
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // No permission, fallback to ISU static search
            startSearchingNearby()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()  // stop updates to save battery
            searchNearbyRestaurants(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Location error: \(error.localizedDescription)"
        // Fallback to ISU location search if needed
        searchNearbyRestaurants(location: isuLocation)
    }
}
