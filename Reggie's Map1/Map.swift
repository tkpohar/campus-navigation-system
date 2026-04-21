import Foundation
import CoreLocation

struct CampusBuilding: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
