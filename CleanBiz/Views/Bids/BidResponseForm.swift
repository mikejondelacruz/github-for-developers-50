import SwiftUI

struct BidResponseForm: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.dismiss) private var dismiss
    let bid: BidRequest

    @State private var estimatedPrice: String = ""
    @State private var estimatedDuration: String = ""
    @State private var notes: String = ""

    var suggestedPrice: Double {
        var price: Double = 120

        // Adjust by property size
        switch bid.propertySize {
        case .small: price *= 0.8
        case .medium: price *= 1.0
        case .large: price *= 1.5
        case .xlarge: price *= 2.0
        }

        // Adjust by service type
        if bid.serviceType.contains("Deep") { price *= 1.8 }
        if bid.serviceType.contains("Move") { price *= 2.0 }
        if bid.serviceType.contains("Construction") { price *= 2.5 }

        // Adjust by rooms
        price += Double(bid.numberOfRooms) * 15
        price += Double(bid.numberOfBathrooms) * 25

        return price
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bid.customerName)
                            .font(.headline)
                        Text(bid.serviceType)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(bid.propertySize.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Suggested Price") {
                    HStack {
                        Text("Based on request details:")
                        Spacer()
                        Text("$\(suggestedPrice, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }

                    Button("Use Suggested Price") {
                        estimatedPrice = String(format: "%.2f", suggestedPrice)
                    }
                    .font(.subheadline)
                }

                Section("Your Quote") {
                    HStack {
                        Text("$")
                        TextField("Price", text: $estimatedPrice)
                            .keyboardType(.decimalPad)
                    }

                    Picker("Estimated Duration", selection: $estimatedDuration) {
                        Text("Select duration").tag("")
                        Text("1-2 hours").tag("1-2 hours")
                        Text("2-3 hours").tag("2-3 hours")
                        Text("3-4 hours").tag("3-4 hours")
                        Text("4-6 hours").tag("4-6 hours")
                        Text("Full day").tag("Full day")
                        Text("Multiple days").tag("Multiple days")
                    }
                }

                Section("Notes to Customer") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }

                Section {
                    Button(action: submitQuote) {
                        HStack {
                            Spacer()
                            Label("Send Quote", systemImage: "paperplane.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(estimatedPrice.isEmpty || estimatedDuration.isEmpty)
                }
            }
            .navigationTitle("Create Quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func submitQuote() {
        guard let price = Double(estimatedPrice) else { return }
        let response = BidResponse(
            estimatedPrice: price,
            estimatedDuration: estimatedDuration,
            notes: notes,
            dateResponded: Date()
        )
        dataStore.submitBidResponse(bid, response: response)
        dismiss()
    }
}
