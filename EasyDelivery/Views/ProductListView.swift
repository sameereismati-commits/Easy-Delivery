import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @EnvironmentObject private var cart: CartViewModel

    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                CategorySidebarView(categories: viewModel.categories, selected: $viewModel.selectedCategory)
                    .frame(width: 110)

                Divider()

                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading products…")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.products.isEmpty {
                        ContentUnavailableView("No products found", systemImage: "magnifyingglass")
                    } else {
                        List(viewModel.products) { product in
                            NavigationLink(value: product) {
                                ProductRow(product: product)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Easy Delivery")
            .searchable(text: $viewModel.searchText, prompt: "Search products")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CartView()
                    } label: {
                        Label("Cart (\(cart.totalItemCount))", systemImage: "cart")
                    }
                }
            }
            .task {
                await viewModel.initialLoad()
            }
        }
    }
}

private struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                Text(product.category.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(product.price, format: .currency(code: "USD"))
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProductListView()
        .environmentObject(CartViewModel())
}
