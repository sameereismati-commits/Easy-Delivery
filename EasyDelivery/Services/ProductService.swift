import Foundation

enum ProductServiceError: Error {
    case invalidURL
    case requestFailed
}

final class ProductService {
    func fetchProducts(category: String? = nil) async throws -> [Product] {
        let urlString: String
        if let category {
            urlString = "https://dummyjson.com/products/category/\(category)"
        } else {
            urlString = "https://dummyjson.com/products?limit=30"
        }

        guard let url = URL(string: urlString) else {
            throw ProductServiceError.invalidURL
        }

        return try await fetchProductResponse(from: url)
    }

    func searchProducts(query: String) async throws -> [Product] {
        var components = URLComponents(string: "https://dummyjson.com/products/search")
        components?.queryItems = [URLQueryItem(name: "q", value: query)]

        guard let url = components?.url else {
            throw ProductServiceError.invalidURL
        }

        return try await fetchProductResponse(from: url)
    }

    func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: "https://dummyjson.com/products/categories") else {
            throw ProductServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ProductServiceError.requestFailed
        }

        return try JSONDecoder().decode([Category].self, from: data)
    }

    private func fetchProductResponse(from url: URL) async throws -> [Product] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ProductServiceError.requestFailed
        }

        let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
        return decoded.products
    }
}
