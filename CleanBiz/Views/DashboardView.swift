import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileStatusCard
                    bidSummarySection
                    recentBidsSection
                }
                .padding()
            }
            .navigationTitle("CleanBiz")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var profileStatusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: dataStore.businessProfile.isProfileComplete ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(dataStore.businessProfile.isProfileComplete ? .green : .orange)

                VStack(alignment: .leading) {
                    Text(dataStore.businessProfile.businessName.isEmpty ? "Set Up Your Business" : dataStore.businessProfile.businessName)
                        .font(.headline)
                    Text(dataStore.businessProfile.isProfileComplete ? "Google Business Profile ready" : "Complete your profile to get started")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var bidSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bid Overview")
                .font(.headline)

            HStack(spacing: 12) {
                StatCard(title: "New", count: dataStore.bidRequests.filter { $0.status == .new }.count, color: .blue)
                StatCard(title: "Quoted", count: dataStore.bidRequests.filter { $0.status == .quoted }.count, color: .purple)
                StatCard(title: "Accepted", count: dataStore.bidRequests.filter { $0.status == .accepted }.count, color: .green)
            }
        }
    }

    private var recentBidsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Requests")
                    .font(.headline)
                Spacer()
                NavigationLink("See All") {
                    BidListView()
                }
                .font(.subheadline)
            }

            if dataStore.bidRequests.isEmpty {
                Text("No bid requests yet.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                ForEach(dataStore.bidRequests.prefix(3)) { bid in
                    NavigationLink(destination: BidDetailView(bid: bid)) {
                        BidRowView(bid: bid)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
