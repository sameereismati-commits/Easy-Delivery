import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cart: CartViewModel

    var body: some View {
        Group {
            if cart.items.isEmpty {
                ContentUnavailableView("Your cart is empty", systemImage: "cart")
            } else {
                VStack(spacing: 0) {
                    List {
                        ForEach(cart.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.product.title)
                                        .font(.headline)
                                    Text(item.product.price, format: .currency(code: "USD"))
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Stepper(value: Binding(
                                    get: { item.quantity },
                                    set: { cart.updateQuantity(for: item, quantity: $0) }
                                ), in: 0...99) {
                                    Text("Qty: \(item.quantity)")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                cart.remove(cart.items[index])
                            }
                        }
                    }

                    VStack(spacing: 12) {
                        HStack {
                            Text("Subtotal")
                            Spacer()
                            Text(cart.subtotal, format: .currency(code: "USD"))
                                .bold()
                        }

                        NavigationLink("Checkout") {
                            CheckoutView()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Cart")
    }
}

#Preview {
    NavigationStack {
        CartView()
            .environmentObject(CartViewModel())
    }
}
