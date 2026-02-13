import SwiftUI

struct BidRowView: View {
    let bid: BidRequest

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(bid.customerName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(bid.status.rawValue)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(statusColor.opacity(0.15))
                        .foregroundStyle(statusColor)
                        .clipShape(Capsule())
                }

                Text(bid.serviceType)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack {
                    Label(bid.propertySize.rawValue, systemImage: "house.fill")
                    Spacer()
                    Text(bid.dateReceived.formatted(.relative(presentation: .named)))
                }
                .font(.caption2)
                .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }

    private var statusColor: Color {
        switch bid.status {
        case .new: return .blue
        case .reviewed: return .orange
        case .quoted: return .purple
        case .accepted: return .green
        case .declined: return .red
        }
    }
}
