import SwiftUI

struct ProductDetailView: View {
    let product: Product

    @EnvironmentObject private var cart: CartViewModel
    @State private var quantity = 1
    @State private var didAddToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: product.thumbnail)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 240)

                Text(product.title)
                    .font(.title2.bold())

                Text(product.category.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(product.price, format: .currency(code: "USD"))
                    .font(.title3.bold())

                Text(product.description)
                    .font(.body)

                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...max(product.stock, 1))

                Button {
                    cart.add(product, quantity: quantity)
                    didAddToCart = true
                } label: {
                    Text("Add to Cart")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Added to Cart", isPresented: $didAddToCart) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(
            product: Product(
                id: 1,
                title: "Sample Product",
                description: "A sample product description for preview purposes.",
                price: 19.99,
                category: "sample",
                thumbnail: "",
                rating: 4.5,
                stock: 10
            )
        )
        .environmentObject(CartViewModel())
    }
}
