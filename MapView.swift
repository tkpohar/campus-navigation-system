import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var vm = MapViewModel()

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.5130, longitude: -88.99),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )

    var body: some View {
        VStack {
            // Search bar
            TextField("Search buildings", text: $vm.searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding([.horizontal, .top])

            // Map with annotations
            Map(position: $cameraPosition, interactionModes: .all) {
                // User location annotation
                if let userCoord = vm.userLocation {
                    Annotation("You", coordinate: userCoord) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 14, height: 14)
                            .shadow(radius: 4)
                    }
                }
                
                // Building annotations filtered by search
                ForEach(vm.filteredBuildings) { building in
                    Annotation(building.name, coordinate: building.coordinate) {
                        VStack(spacing: 2) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                        .onTapGesture {
                            vm.selectedBuilding = building
                            withAnimation {
                                cameraPosition = .region(
                                    MKCoordinateRegion(
                                        center: building.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    )
                                )
                            }
                            vm.route = nil
                        }
                    }
                }
                
                // Route polyline
                if let route = vm.route {
                    MapPolyline(route.polyline)
                        .stroke(Color.blue, lineWidth: 4)
                }
            }
            .ignoresSafeArea()

            // Directions & Map Buttons
            if let selected = vm.selectedBuilding {
                VStack(spacing: 8) {
                    Text("Directions to \(selected.name)")
                        .font(.headline)
                        .padding(.top)

                    if let route = vm.route {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(route.steps, id: \.self) { step in
                                    Text(step.instructions)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 200)
                    }

                    Button("Get Route") {
                        vm.calculateRoute(to: selected.coordinate)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)

                    HStack(spacing: 10) {
                        Button(action: {
                            vm.openInAppleMaps(coordinate: selected.coordinate, name: selected.name)
                        }) {
                            Label("Open in Apple Maps", systemImage: "map")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                .background(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    MapView()
}
