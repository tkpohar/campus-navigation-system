import Foundation

struct NewsItem: Identifiable {
    let id = UUID()
    var title: String
    var link: String
    var pubDate: String
    var imageURL: URL?
}
