import Foundation

struct BusinessProfile: Codable, Identifiable {
    var id: UUID = UUID()
    var businessName: String = ""
    var ownerName: String = ""
    var phone: String = ""
    var email: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zipCode: String = ""
    var website: String = ""
    var description: String = ""
    var servicesOffered: [CleaningService] = []
    var businessHours: [BusinessDay] = BusinessDay.defaultWeek()
    var isProfileComplete: Bool {
        !businessName.isEmpty && !phone.isEmpty && !address.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty
    }
}

struct CleaningService: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var basePrice: Double

    static let suggestions: [CleaningService] = [
        CleaningService(name: "Standard Cleaning", description: "Regular house cleaning including dusting, vacuuming, mopping, and bathroom cleaning", basePrice: 120),
        CleaningService(name: "Deep Cleaning", description: "Thorough top-to-bottom cleaning including baseboards, inside appliances, and detailed scrubbing", basePrice: 250),
        CleaningService(name: "Move-In/Move-Out", description: "Complete cleaning for empty homes before or after a move", basePrice: 300),
        CleaningService(name: "Post-Construction", description: "Heavy-duty cleaning after renovation or construction work", basePrice: 400),
        CleaningService(name: "Office Cleaning", description: "Commercial office space cleaning and sanitization", basePrice: 200),
        CleaningService(name: "Carpet Cleaning", description: "Professional carpet shampooing and stain removal", basePrice: 150),
        CleaningService(name: "Window Cleaning", description: "Interior and exterior window washing", basePrice: 100),
        CleaningService(name: "Laundry Service", description: "Wash, dry, fold, and organize clothing and linens", basePrice: 75)
    ]
}

struct BusinessDay: Codable, Identifiable {
    var id: UUID = UUID()
    var dayName: String
    var isOpen: Bool
    var openTime: Date
    var closeTime: Date

    static func defaultWeek() -> [BusinessDay] {
        let calendar = Calendar.current
        let open = calendar.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
        let close = calendar.date(from: DateComponents(hour: 17, minute: 0)) ?? Date()

        return [
            BusinessDay(dayName: "Monday", isOpen: true, openTime: open, closeTime: close),
            BusinessDay(dayName: "Tuesday", isOpen: true, openTime: open, closeTime: close),
            BusinessDay(dayName: "Wednesday", isOpen: true, openTime: open, closeTime: close),
            BusinessDay(dayName: "Thursday", isOpen: true, openTime: open, closeTime: close),
            BusinessDay(dayName: "Friday", isOpen: true, openTime: open, closeTime: close),
            BusinessDay(dayName: "Saturday", isOpen: true, openTime: open, closeTime: close),
            BusinessDay(dayName: "Sunday", isOpen: false, openTime: open, closeTime: close)
        ]
    }
}
