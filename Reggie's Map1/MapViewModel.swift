import Foundation
import MapKit
import CoreLocation
import UIKit

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var buildings: [CampusBuilding] = []
    @Published var selectedBuilding: CampusBuilding?
    @Published var route: MKRoute?
    @Published var searchText: String = ""

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        loadBuildings()
    }
    
    func loadBuildings() {
        buildings = [
            CampusBuilding(name: "Office of Sustainability", coordinate: CLLocationCoordinate2D(latitude: 40.51354, longitude: -88.99003)),
            CampusBuilding(name: "Kingsley CampusBuilding Suite B", coordinate: CLLocationCoordinate2D(latitude: 40.50833, longitude: -88.99628)),
            CampusBuilding(name: "Alumni Center", coordinate: CLLocationCoordinate2D(latitude: 40.52513, longitude: -88.99686)),
            CampusBuilding(name: "Ropp Agriculture CampusBuilding", coordinate: CLLocationCoordinate2D(latitude: 40.51336, longitude: -88.99554)),
            CampusBuilding(name: "Art Studio CampusBuilding", coordinate: CLLocationCoordinate2D(latitude: 40.50674, longitude: -88.99078)),
            CampusBuilding(name: "Bone Student Center", coordinate: CLLocationCoordinate2D(latitude: 40.51183, longitude: -88.99224)),
            CampusBuilding(name: "Braden Auditorium", coordinate: CLLocationCoordinate2D(latitude: 40.51126, longitude: -88.99227)),
            CampusBuilding(name: "Campus Recreation Operations", coordinate: CLLocationCoordinate2D(latitude: 40.508, longitude: -88.99369)),
            CampusBuilding(name: "DeGarmo Hall", coordinate: CLLocationCoordinate2D(latitude: 40.50894, longitude: -88.99265)),
            CampusBuilding(name: "Edwards Hall", coordinate: CLLocationCoordinate2D(latitude: 40.50987, longitude: -88.99217)),
            CampusBuilding(name: "Ewing Manor", coordinate: CLLocationCoordinate2D(latitude: 40.49381, longitude: -88.96571)),
            CampusBuilding(name: "University Farm Areas", coordinate: CLLocationCoordinate2D(latitude: 40.66767, longitude: -88.77288)),
            CampusBuilding(name: "John Green Food Science", coordinate: CLLocationCoordinate2D(latitude: 40.51683, longitude: -88.99624)),
            CampusBuilding(name: "Campus Services CampusBuilding", coordinate: CLLocationCoordinate2D(latitude: 40.53145, longitude: -88.99995)),
            CampusBuilding(name: "Hancock Stadium", coordinate: CLLocationCoordinate2D(latitude: 40.5125, longitude: -88.99662)),
            CampusBuilding(name: "Risk Management", coordinate: CLLocationCoordinate2D(latitude: 40.51322, longitude: -88.99111)),
            CampusBuilding(name: "Hovey Hall", coordinate: CLLocationCoordinate2D(latitude: 40.5094, longitude: -88.98997)),
            CampusBuilding(name: "Heating Plant", coordinate: CLLocationCoordinate2D(latitude: 40.5103, longitude: -88.9929)),
            CampusBuilding(name: "Honors Program CampusBuilding", coordinate: CLLocationCoordinate2D(latitude: 40.5091, longitude: -88.99508)),
            CampusBuilding(name: "Horton Field House", coordinate: CLLocationCoordinate2D(latitude: 40.5122, longitude: -88.99853)),
            CampusBuilding(name: "ROTC CampusBuilding", coordinate: CLLocationCoordinate2D(latitude: 40.51188, longitude: -88.99373)),
            CampusBuilding(name: "Linkins Center", coordinate: CLLocationCoordinate2D(latitude: 40.51218, longitude: -89.00051)),
            CampusBuilding(name: "Multicultural Center", coordinate: CLLocationCoordinate2D(latitude: 40.50833, longitude: -88.99518)),
            CampusBuilding(name: "MCN Simulation Center / Milner Library", coordinate: CLLocationCoordinate2D(latitude: 40.51139, longitude: -88.99076)),
            CampusBuilding(name: "Moulton Hall", coordinate: CLLocationCoordinate2D(latitude: 40.50989, longitude: -88.99036)),
            CampusBuilding(name: "Housing & ORL", coordinate: CLLocationCoordinate2D(latitude: 40.50697, longitude: -88.99272)),
            CampusBuilding(name: "Old Union", coordinate: CLLocationCoordinate2D(latitude: 40.50876, longitude: -88.98997)),
            CampusBuilding(name: "Professional Development CampusBuilding Annex", coordinate: CLLocationCoordinate2D(latitude: 40.50939, longitude: -88.99532)),
            CampusBuilding(name: "Football Practice Field", coordinate: CLLocationCoordinate2D(latitude: 40.51352, longitude: -88.99733)),
            CampusBuilding(name: "Schroeder Hall", coordinate: CLLocationCoordinate2D(latitude: 40.51031, longitude: -88.99183)),
            CampusBuilding(name: "Student Fitness Center/McCormick Hall", coordinate: CLLocationCoordinate2D(latitude: 40.508, longitude: -88.99369)),
            CampusBuilding(name: "Turner Child Care Center", coordinate: CLLocationCoordinate2D(latitude: 40.51079, longitude: -88.99708)),
            CampusBuilding(name: "University High School", coordinate: CLLocationCoordinate2D(latitude: 40.51556, longitude: -88.99609)),
            CampusBuilding(name: "Uptown Station Gallery", coordinate: CLLocationCoordinate2D(latitude: 40.50835, longitude: -88.98556)),
            CampusBuilding(name: "Vitro Center", coordinate: CLLocationCoordinate2D(latitude: 40.51398, longitude: -88.99617)),
            CampusBuilding(name: "Watterson Dining Commons", coordinate: CLLocationCoordinate2D(latitude: 40.50902, longitude: -88.98766)),
            CampusBuilding(name: "Williams Hall", coordinate: CLLocationCoordinate2D(latitude: 40.50822, longitude: -88.98988)),
            CampusBuilding(name: "Warehouse Road Complex 1", coordinate: CLLocationCoordinate2D(latitude: 40.5439, longitude: -88.98809)),
            CampusBuilding(name: "Warehouse Road Complex 2", coordinate: CLLocationCoordinate2D(latitude: 40.54497, longitude: -88.98852))
        ]
    }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }

        func calculateRoute(to destination: CLLocationCoordinate2D) {
            guard let userLoc = userLocation else { return }
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLoc))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate { [weak self] response, error in
                if let route = response?.routes.first {
                    DispatchQueue.main.async {
                        self?.route = route
                    }
                }
            }
        }
        
        var filteredBuildings: [CampusBuilding] {
            if searchText.isEmpty {
                return buildings
            } else {
                return buildings.filter {
                    $0.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }

        // Open Apple Maps with the destination coordinate
        func openInAppleMaps(coordinate: CLLocationCoordinate2D, name: String) {
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = name
            mapItem.openInMaps(launchOptions: nil)
        }
        
        // Open Google Maps if installed, else fallback to Apple Maps
        func openInGoogleMaps(coordinate: CLLocationCoordinate2D) {
            let urlStr = "comgooglemaps://?q=\(coordinate.latitude),\(coordinate.longitude)&zoom=14"
            if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // Google Maps app not installed, open Apple Maps instead
                openInAppleMaps(coordinate: coordinate, name: "")
            }
        }
    }
