import Foundation

enum DeliverySlot: String, CaseIterable, Identifiable {
    case morning = "Today, 10am - 12pm"
    case afternoon = "Today, 2pm - 4pm"
    case evening = "Today, 6pm - 8pm"
    case tomorrow = "Tomorrow, 10am - 12pm"

    var id: String { rawValue }
}
