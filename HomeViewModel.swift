import Foundation
import Combine

class HomeViewModel: NSObject, ObservableObject, XMLParserDelegate {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentDescription = ""
    private var tempArticles: [NewsArticle] = []
    private var itemCount = 0

    func fetchNews() async {
        print("Starting fetchNews()")
        tempArticles = []
        itemCount = 0

        await MainActor.run {
            self.articles = []
            self.isLoading = true
            self.errorMessage = nil
        }

        guard let url = URL(string: "https://news.illinoisstate.edu/feed/") else {
            print("Invalid RSS feed URL")
            await MainActor.run {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            let parser = XMLParser(data: data)
            parser.delegate = self
            if !parser.parse() {
                print("Failed to parse RSS feed")
                await MainActor.run {
                    self.errorMessage = "Failed to parse RSS feed"
                }
            }

            print("Parsed articles count: \(tempArticles.count)")
            await MainActor.run {
                self.articles = self.tempArticles
                self.isLoading = false
            }

        } catch {
            print("Failed to fetch RSS feed: \(error.localizedDescription)")
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    // MARK: - XMLParserDelegate methods

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if itemCount < 2 {
                let article = NewsArticle(
                    title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                    summary: currentDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                    link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                    imageUrl: nil
                )
                tempArticles.append(article)
                itemCount += 1
            } else {
                parser.abortParsing()
            }
        }
    }
}
