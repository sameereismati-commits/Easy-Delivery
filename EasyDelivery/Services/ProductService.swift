import Foundation

enum ProductServiceError: Error {
    case invalidURL
    case requestFailed
}

final class ProductService {
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "https://dummyjson.com/products?limit=30") else {
            throw ProductServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ProductServiceError.requestFailed
        }

        let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
        return decoded.products
    }
}
