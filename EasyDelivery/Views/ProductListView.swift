import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading products…")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.secondary)
                } else {
                    List(viewModel.products) { product in
                        HStack {
                            AsyncImage(url: URL(string: product.thumbnail)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)

                            VStack(alignment: .leading) {
                                Text(product.title)
                                    .font(.headline)
                                Text(product.price, format: .currency(code: "USD"))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Easy Delivery")
            .task {
                await viewModel.loadProducts()
            }
        }
    }
}

#Preview {
    ProductListView()
}
