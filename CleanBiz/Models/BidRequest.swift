import Foundation

struct BidRequest: Codable, Identifiable {
    var id: UUID = UUID()
    var customerName: String
    var customerPhone: String
    var customerEmail: String
    var address: String
    var serviceType: String
    var propertySize: PropertySize
    var numberOfRooms: Int
    var numberOfBathrooms: Int
    var specialRequests: String
    var preferredDate: Date
    var status: BidStatus
    var dateReceived: Date
    var bidResponse: BidResponse?
}

enum PropertySize: String, Codable, CaseIterable {
    case small = "Small (< 1,000 sq ft)"
    case medium = "Medium (1,000 - 2,000 sq ft)"
    case large = "Large (2,000 - 3,500 sq ft)"
    case xlarge = "X-Large (3,500+ sq ft)"
}

enum BidStatus: String, Codable, CaseIterable {
    case new = "New"
    case reviewed = "Reviewed"
    case quoted = "Quoted"
    case accepted = "Accepted"
    case declined = "Declined"

    var color: String {
        switch self {
        case .new: return "blue"
        case .reviewed: return "orange"
        case .quoted: return "purple"
        case .accepted: return "green"
        case .declined: return "red"
        }
    }
}

struct BidResponse: Codable {
    var estimatedPrice: Double
    var estimatedDuration: String
    var notes: String
    var dateResponded: Date
}

extension BidRequest {
    static let sampleRequests: [BidRequest] = [
        BidRequest(
            customerName: "Sarah Johnson",
            customerPhone: "(555) 123-4567",
            customerEmail: "sarah.j@email.com",
            address: "142 Oak Street, Springfield",
            serviceType: "Deep Cleaning",
            propertySize: .large,
            numberOfRooms: 5,
            numberOfBathrooms: 3,
            specialRequests: "Pet-friendly products only please. We have two dogs.",
            preferredDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
            status: .new,
            dateReceived: Date()
        ),
        BidRequest(
            customerName: "Mike Chen",
            customerPhone: "(555) 987-6543",
            customerEmail: "mike.chen@email.com",
            address: "88 Elm Avenue, Apt 4B",
            serviceType: "Standard Cleaning",
            propertySize: .small,
            numberOfRooms: 2,
            numberOfBathrooms: 1,
            specialRequests: "Bi-weekly recurring service preferred.",
            preferredDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
            status: .new,
            dateReceived: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date()
        ),
        BidRequest(
            customerName: "Jessica Williams",
            customerPhone: "(555) 456-7890",
            customerEmail: "jwilliams@email.com",
            address: "2200 Pine Road",
            serviceType: "Move-In/Move-Out",
            propertySize: .xlarge,
            numberOfRooms: 6,
            numberOfBathrooms: 4,
            specialRequests: "Moving out March 15. Need full clean including garage.",
            preferredDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
            status: .reviewed,
            dateReceived: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        ),
        BidRequest(
            customerName: "Tom Baker",
            customerPhone: "(555) 321-0987",
            customerEmail: "tombaker@email.com",
            address: "55 Maple Drive, Suite 100",
            serviceType: "Office Cleaning",
            propertySize: .medium,
            numberOfRooms: 4,
            numberOfBathrooms: 2,
            specialRequests: "After hours only (after 6 PM). Weekly service.",
            preferredDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
            status: .quoted,
            dateReceived: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            bidResponse: BidResponse(
                estimatedPrice: 175.00,
                estimatedDuration: "2-3 hours",
                notes: "Weekly service rate applied. After-hours surcharge included.",
                dateResponded: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
            )
        )
    ]
}
