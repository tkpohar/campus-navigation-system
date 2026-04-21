import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            await viewModel.fetchNews()
                        }
                    }) {
            
        
                    }

                }
                .padding(.top)

                Text("Welcome to Illinois State University")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)

                VStack(spacing: 8) {
                    Text("Mission")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    Text("To prepare diverse, engaged, and informed members of society through collaborative teaching, scholarship, and service.")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

                HStack {
                    Spacer()
                    Image("campus")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    Spacer()
                }
                .padding(.vertical, 10)

                VStack(spacing: 12) {
                    Text("ISU News")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)

                    if viewModel.articles.isEmpty {
                        ProgressView("Loading news...")
                            .padding(.horizontal)
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(viewModel.articles.prefix(2).enumerated()), id: \.1.id) { index, article in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(article.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Text(article.summary)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                                .padding(.horizontal)

                                if index != viewModel.articles.prefix(2).count - 1 {
                                    Divider()
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                }
                            }
                        }
                    }
                }

                Spacer(minLength: 40)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchNews()
            }
        }
    }
}

#Preview {
    HomeView()
}
