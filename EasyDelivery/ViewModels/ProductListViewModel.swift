import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var selectedCategory: Category? {
        didSet {
            guard oldValue != selectedCategory else { return }
            Task { await loadProducts() }
        }
    }

    @Published var searchText: String = "" {
        didSet {
            guard oldValue != searchText else { return }
            searchTask?.cancel()
            searchTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 300_000_000)
                guard !Task.isCancelled else { return }
                await self?.loadProducts()
            }
        }
    }

    private let service = ProductService()
    private var searchTask: Task<Void, Never>?

    func initialLoad() async {
        await loadCategories()
        await loadProducts()
    }

    func loadCategories() async {
        do {
            categories = try await service.fetchCategories()
        } catch {
            categories = []
        }
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            if !searchText.isEmpty {
                products = try await service.searchProducts(query: searchText)
            } else {
                products = try await service.fetchProducts(category: selectedCategory?.slug)
            }
        } catch {
            errorMessage = "Couldn't load products. Please try again."
        }

        isLoading = false
    }
}
