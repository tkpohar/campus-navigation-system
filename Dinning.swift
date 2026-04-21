import Foundation
import CoreLocation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let phone: String?
    let website: String?
    let image: String?           // Optional for static/fallback images
    let coordinate: CLLocationCoordinate2D?
}
