import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []

    func add(_ product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(id: product.id, product: product, quantity: quantity))
        }
    }

    var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    func remove(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    func updateQuantity(for item: CartItem, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if quantity <= 0 {
            items.remove(at: index)
        } else {
            items[index].quantity = quantity
        }
    }

    func clear() {
        items.removeAll()
    }
}
