import Foundation

struct DeliveryAddress {
    var street: String = ""
    var city: String = ""
    var zipCode: String = ""

    var isValid: Bool {
        !street.trimmingCharacters(in: .whitespaces).isEmpty
            && !city.trimmingCharacters(in: .whitespaces).isEmpty
            && isZipCodeValid
    }

    var isZipCodeValid: Bool {
        zipCode.count == 5 && zipCode.allSatisfy(\.isNumber)
    }
}
