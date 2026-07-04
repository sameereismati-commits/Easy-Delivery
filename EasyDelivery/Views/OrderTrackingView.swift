import SwiftUI

struct OrderTrackingView: View {
    @EnvironmentObject private var orderViewModel: OrderViewModel
    @EnvironmentObject private var auth: AuthViewModel
    @State private var didSendReceipt = false

    var body: some View {
        ScrollView {
            if let order = orderViewModel.currentOrder {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Order Confirmed!")
                        .font(.title.bold())

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            HStack {
                                Image(systemName: isReached(status, order: order) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(isReached(status, order: order) ? .green : .gray)
                                Text(status.rawValue)
                                    .foregroundStyle(isReached(status, order: order) ? .primary : .secondary)
                            }
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Delivering to")
                            .font(.headline)
                        Text("\(order.address.street), \(order.address.city) \(order.address.zipCode)")
                        Text(order.deliverySlot.rawValue)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Items")
                            .font(.headline)
                        ForEach(order.items) { item in
                            HStack {
                                Text("\(item.quantity)x \(item.product.title)")
                                Spacer()
                                Text(item.product.price * Double(item.quantity), format: .currency(code: "USD"))
                            }
                        }
                    }

                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(order.total, format: .currency(code: "USD"))
                            .font(.headline)
                    }

                    Button {
                        didSendReceipt = true
                    } label: {
                        Label("Email Receipt", systemImage: "envelope")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .padding()
            } else {
                ContentUnavailableView("No active order", systemImage: "shippingbox")
            }
        }
        .navigationTitle("Order Status")
        .alert("Receipt Sent", isPresented: $didSendReceipt) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("A receipt has been emailed to \(auth.email.isEmpty ? "your email" : auth.email).")
        }
    }

    private func isReached(_ status: OrderStatus, order: Order) -> Bool {
        let all = OrderStatus.allCases
        guard let currentIndex = all.firstIndex(of: order.status),
              let statusIndex = all.firstIndex(of: status) else { return false }
        return statusIndex <= currentIndex
    }
}

#Preview {
    NavigationStack {
        OrderTrackingView()
            .environmentObject(OrderViewModel())
            .environmentObject(AuthViewModel())
    }
}
