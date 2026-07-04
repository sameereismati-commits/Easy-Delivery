import Foundation

struct CartItem: Identifiable {
    let id: Int
    let product: Product
    var quantity: Int
}
