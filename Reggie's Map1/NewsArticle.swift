import Foundation

struct NewsArticle: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let link: String
    let imageUrl: URL?
}
