import Foundation

struct Category: Codable, Identifiable, Equatable {
    let slug: String
    let name: String
    let url: String

    var id: String { slug }
}
