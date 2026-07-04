import Foundation

enum OrderStatus: String, CaseIterable {
    case placed = "Order Placed"
    case preparing = "Preparing"
    case outForDelivery = "Out for Delivery"
    case delivered = "Delivered"

    var next: OrderStatus? {
        let all = OrderStatus.allCases
        guard let index = all.firstIndex(of: self), index + 1 < all.count else { return nil }
        return all[index + 1]
    }
}

struct Order: Identifiable {
    let id = UUID()
    let items: [CartItem]
    let address: DeliveryAddress
    let deliverySlot: DeliverySlot
    let total: Double
    var status: OrderStatus = .placed
    let placedAt: Date = Date()
}
