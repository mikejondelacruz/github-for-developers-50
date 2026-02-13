import SwiftUI

struct BidListView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var filterStatus: BidStatus?
    @State private var showingNewBid = false

    var filteredBids: [BidRequest] {
        if let status = filterStatus {
            return dataStore.bidRequests.filter { $0.status == status }
        }
        return dataStore.bidRequests
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                List {
                    ForEach(filteredBids) { bid in
                        NavigationLink(destination: BidDetailView(bid: bid)) {
                            BidRowView(bid: bid)
                        }
                    }
                    .onDelete { offsets in
                        let idsToDelete = offsets.map { filteredBids[$0].id }
                        for id in idsToDelete {
                            if let index = dataStore.bidRequests.firstIndex(where: { $0.id == id }) {
                                dataStore.bidRequests.remove(at: index)
                            }
                        }
                        dataStore.saveBids()
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if filteredBids.isEmpty {
                        ContentUnavailableView(
                            "No Bid Requests",
                            systemImage: "doc.text.magnifyingglass",
                            description: Text(filterStatus != nil ? "No \(filterStatus!.rawValue.lowercased()) bids found." : "Bid requests from customers will appear here.")
                        )
                    }
                }
            }
            .navigationTitle("Bid Requests")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingNewBid = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewBid) {
                NewBidRequestView()
            }
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: filterStatus == nil) {
                    filterStatus = nil
                }

                ForEach(BidStatus.allCases, id: \.self) { status in
                    let count = dataStore.bidRequests.filter { $0.status == status }.count
                    FilterChip(title: "\(status.rawValue) (\(count))", isSelected: filterStatus == status) {
                        filterStatus = status
                    }
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
