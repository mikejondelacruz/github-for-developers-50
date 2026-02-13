import SwiftUI

struct BidDetailView: View {
    @EnvironmentObject var dataStore: DataStore
    let bid: BidRequest
    @State private var showingResponseForm = false

    private var currentBid: BidRequest {
        dataStore.bidRequests.first(where: { $0.id == bid.id }) ?? bid
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                statusBanner
                customerSection
                propertySection
                serviceSection
                if currentBid.bidResponse != nil {
                    responseSection
                }
                actionButtons
            }
            .padding()
        }
        .navigationTitle("Bid Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingResponseForm) {
            BidResponseForm(bid: currentBid)
        }
    }

    private var statusBanner: some View {
        HStack {
            Image(systemName: statusIcon)
            Text(currentBid.status.rawValue)
                .fontWeight(.semibold)
            Spacer()
            Text("Received \(currentBid.dateReceived.formatted(.relative(presentation: .named)))")
                .font(.caption)
        }
        .padding()
        .background(statusColor.opacity(0.1))
        .foregroundStyle(statusColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var customerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Customer Information")

            InfoRow(icon: "person.fill", label: "Name", value: currentBid.customerName)
            InfoRow(icon: "phone.fill", label: "Phone", value: currentBid.customerPhone)
            InfoRow(icon: "envelope.fill", label: "Email", value: currentBid.customerEmail)
            InfoRow(icon: "mappin.circle.fill", label: "Address", value: currentBid.address)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var propertySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Property Details")

            InfoRow(icon: "house.fill", label: "Size", value: currentBid.propertySize.rawValue)
            InfoRow(icon: "bed.double.fill", label: "Rooms", value: "\(currentBid.numberOfRooms)")
            InfoRow(icon: "shower.fill", label: "Bathrooms", value: "\(currentBid.numberOfBathrooms)")
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var serviceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Service Request")

            InfoRow(icon: "sparkles", label: "Type", value: currentBid.serviceType)
            InfoRow(icon: "calendar", label: "Preferred Date", value: currentBid.preferredDate.formatted(date: .abbreviated, time: .omitted))

            if !currentBid.specialRequests.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Special Requests")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(currentBid.specialRequests)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var responseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Your Quote")

            if let response = currentBid.bidResponse {
                InfoRow(icon: "dollarsign.circle.fill", label: "Price", value: "$\(response.estimatedPrice, specifier: "%.2f")")
                InfoRow(icon: "clock.fill", label: "Duration", value: response.estimatedDuration)
                if !response.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(response.notes)
                            .font(.subheadline)
                    }
                }
                Text("Sent \(response.dateResponded.formatted(.relative(presentation: .named)))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if currentBid.status == .new {
                Button(action: {
                    dataStore.updateBidStatus(currentBid, status: .reviewed)
                }) {
                    HStack {
                        Spacer()
                        Label("Mark as Reviewed", systemImage: "eye.fill")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            if currentBid.status != .quoted && currentBid.status != .accepted && currentBid.status != .declined {
                Button(action: { showingResponseForm = true }) {
                    HStack {
                        Spacer()
                        Label("Send Quote", systemImage: "paperplane.fill")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            if currentBid.status == .quoted {
                HStack(spacing: 12) {
                    Button(action: {
                        dataStore.updateBidStatus(currentBid, status: .accepted)
                    }) {
                        HStack {
                            Spacer()
                            Label("Accepted", systemImage: "checkmark.circle.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Button(action: {
                        dataStore.updateBidStatus(currentBid, status: .declined)
                    }) {
                        HStack {
                            Spacer()
                            Label("Declined", systemImage: "xmark.circle.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }

    private var statusIcon: String {
        switch currentBid.status {
        case .new: return "bell.fill"
        case .reviewed: return "eye.fill"
        case .quoted: return "paperplane.fill"
        case .accepted: return "checkmark.circle.fill"
        case .declined: return "xmark.circle.fill"
        }
    }

    private var statusColor: Color {
        switch currentBid.status {
        case .new: return .blue
        case .reviewed: return .orange
        case .quoted: return .purple
        case .accepted: return .green
        case .declined: return .red
        }
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.subheadline)
        }
    }
}
