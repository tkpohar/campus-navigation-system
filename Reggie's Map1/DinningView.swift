import SwiftUI

struct DinningView: View {
    @StateObject private var viewModel = DinningModelView()

    var body: some View {
        NavigationView {
            VStack {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if viewModel.isLoading {
                    ProgressView("Searching nearby restaurants...")
                        .padding()
                } else if viewModel.restaurants.isEmpty {
                    Text("No restaurants found nearby.")
                        .padding()
                } else {
                    List(viewModel.restaurants) { restaurant in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(restaurant.name)
                                .font(.headline)
                            Text(restaurant.address)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            if let phone = restaurant.phone {
                                Text("Phone: \(phone)")
                                    .font(.footnote)
                            }
                            if let website = restaurant.website {
                                Text("Website: \(website)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Nearby Restaurants")
            .toolbar {
                Button(action: {
                    viewModel.startSearchingNearby()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .accessibilityLabel("Refresh")
            }
            .onAppear {
                viewModel.startSearchingNearby()
            }
        }
    }
}

#Preview {
    DinningView()
}
