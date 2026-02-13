import SwiftUI

struct GoogleProfilePreview: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.dismiss) private var dismiss

    private var profile: BusinessProfile { dataStore.businessProfile }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    Divider()
                    infoSection
                    Divider()
                    hoursSection
                    Divider()
                    servicesSection
                    Divider()
                    actionsSection
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("Profile Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.2))
                .frame(height: 160)
                .overlay {
                    VStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundStyle(Color.accentColor)
                        Text("Cover Photo")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

            Text(profile.businessName)
                .font(.title2)
                .fontWeight(.bold)

            Text("Cleaning Service")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < 4 ? "star.fill" : "star.leadinghalf.filled")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                }
                Text("4.5")
                    .font(.caption)
                    .fontWeight(.medium)
                Text("(New Business)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(profile.isProfileComplete ? "Open now" : "Hours not set")
                .font(.caption)
                .foregroundStyle(profile.isProfileComplete ? .green : .secondary)
        }
        .padding()
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Business Info")
                .font(.headline)

            if !profile.address.isEmpty {
                Label("\(profile.address), \(profile.city), \(profile.state) \(profile.zipCode)", systemImage: "mappin.circle.fill")
                    .font(.subheadline)
            }

            if !profile.phone.isEmpty {
                Label(profile.phone, systemImage: "phone.circle.fill")
                    .font(.subheadline)
            }

            if !profile.website.isEmpty {
                Label(profile.website, systemImage: "globe")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }

            if !profile.description.isEmpty {
                Text(profile.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
    }

    private var hoursSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hours")
                .font(.headline)

            let formatter = DateFormatter()

            ForEach(profile.businessHours) { day in
                HStack {
                    Text(day.dayName)
                        .font(.subheadline)
                        .frame(width: 90, alignment: .leading)
                    if day.isOpen {
                        Text("\(formatTime(day.openTime)) - \(formatTime(day.closeTime))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Closed")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .padding()
    }

    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Services")
                .font(.headline)

            if profile.servicesOffered.isEmpty {
                Text("No services listed yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(profile.servicesOffered) { service in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(service.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(service.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("From $\(service.basePrice, specifier: "%.0f")")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.green)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .padding()
    }

    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button(action: {}) {
                HStack {
                    Spacer()
                    Label("Request a Quote", systemImage: "envelope.fill")
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button(action: {}) {
                HStack {
                    Spacer()
                    Label("Call Now", systemImage: "phone.fill")
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
