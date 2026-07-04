import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let category: String
    let thumbnail: String
    let rating: Double
    let stock: Int
}

struct ProductResponse: Codable {
    let products: [Product]
}
