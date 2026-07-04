import Foundation
import Combine

@MainActor
final class OrderViewModel: ObservableObject {
    @Published var currentOrder: Order?

    private var trackingTask: Task<Void, Never>?

    func placeOrder(items: [CartItem], address: DeliveryAddress, slot: DeliverySlot, total: Double) {
        currentOrder = Order(items: items, address: address, deliverySlot: slot, total: total)
        startTracking()
    }

    private func startTracking() {
        trackingTask?.cancel()
        trackingTask = Task { [weak self] in
            while let self, let order = self.currentOrder, order.status.next != nil {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                guard !Task.isCancelled else { return }
                self.advanceStatus()
            }
        }
    }

    private func advanceStatus() {
        guard var order = currentOrder, let next = order.status.next else { return }
        order.status = next
        currentOrder = order
    }
}
