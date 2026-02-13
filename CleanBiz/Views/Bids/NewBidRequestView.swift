import SwiftUI

struct NewBidRequestView: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.dismiss) private var dismiss

    @State private var customerName = ""
    @State private var customerPhone = ""
    @State private var customerEmail = ""
    @State private var address = ""
    @State private var serviceType = "Standard Cleaning"
    @State private var propertySize: PropertySize = .medium
    @State private var numberOfRooms = 3
    @State private var numberOfBathrooms = 2
    @State private var specialRequests = ""
    @State private var preferredDate = Date()

    private let serviceTypes = [
        "Standard Cleaning",
        "Deep Cleaning",
        "Move-In/Move-Out",
        "Post-Construction",
        "Office Cleaning",
        "Carpet Cleaning",
        "Window Cleaning"
    ]

    var isFormValid: Bool {
        !customerName.isEmpty && !customerPhone.isEmpty && !address.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Customer Info") {
                    TextField("Name", text: $customerName)
                        .textContentType(.name)
                    TextField("Phone", text: $customerPhone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $customerEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section("Property") {
                    TextField("Address", text: $address)
                        .textContentType(.fullStreetAddress)
                    Picker("Property Size", selection: $propertySize) {
                        ForEach(PropertySize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    Stepper("Rooms: \(numberOfRooms)", value: $numberOfRooms, in: 1...20)
                    Stepper("Bathrooms: \(numberOfBathrooms)", value: $numberOfBathrooms, in: 1...10)
                }

                Section("Service") {
                    Picker("Service Type", selection: $serviceType) {
                        ForEach(serviceTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    DatePicker("Preferred Date", selection: $preferredDate, in: Date()..., displayedComponents: .date)
                }

                Section("Special Requests") {
                    TextEditor(text: $specialRequests)
                        .frame(minHeight: 60)
                }

                Section {
                    Button(action: createBidRequest) {
                        HStack {
                            Spacer()
                            Label("Create Bid Request", systemImage: "plus.circle.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("New Bid Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func createBidRequest() {
        let bid = BidRequest(
            customerName: customerName,
            customerPhone: customerPhone,
            customerEmail: customerEmail,
            address: address,
            serviceType: serviceType,
            propertySize: propertySize,
            numberOfRooms: numberOfRooms,
            numberOfBathrooms: numberOfBathrooms,
            specialRequests: specialRequests,
            preferredDate: preferredDate,
            status: .new,
            dateReceived: Date()
        )
        dataStore.addBidRequest(bid)
        dismiss()
    }
}
