import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var cart: CartViewModel
    @EnvironmentObject private var orderViewModel: OrderViewModel

    @State private var address = DeliveryAddress()
    @State private var selectedSlot: DeliverySlot = .morning
    @State private var navigateToTracking = false

    var body: some View {
        Form {
            Section("Delivery Address") {
                TextField("Street", text: $address.street)

                TextField("City", text: $address.city)

                TextField("ZIP Code", text: $address.zipCode)
                    .keyboardType(.numberPad)
                if !address.zipCode.isEmpty && !address.isZipCodeValid {
                    Text("ZIP code must be 5 digits")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            Section("Delivery Time") {
                Picker("Time Slot", selection: $selectedSlot) {
                    ForEach(DeliverySlot.allCases) { slot in
                        Text(slot.rawValue).tag(slot)
                    }
                }
                .pickerStyle(.inline)
            }

            Section {
                HStack {
                    Text("Total")
                    Spacer()
                    Text(cart.subtotal, format: .currency(code: "USD"))
                        .bold()
                }
            }

            Section {
                Button("Place Order") {
                    orderViewModel.placeOrder(
                        items: cart.items,
                        address: address,
                        slot: selectedSlot,
                        total: cart.subtotal
                    )
                    cart.clear()
                    navigateToTracking = true
                }
                .disabled(!address.isValid)
            }
        }
        .navigationTitle("Checkout")
        .navigationDestination(isPresented: $navigateToTracking) {
            OrderTrackingView()
        }
    }
}

#Preview {
    NavigationStack {
        CheckoutView()
            .environmentObject(CartViewModel())
            .environmentObject(OrderViewModel())
    }
}
