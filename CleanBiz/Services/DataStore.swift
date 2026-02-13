import Foundation
import SwiftUI

@MainActor
class DataStore: ObservableObject {
    @Published var businessProfile: BusinessProfile
    @Published var bidRequests: [BidRequest]

    private let profileKey = "businessProfile"
    private let bidsKey = "bidRequests"

    init() {
        if let profileData = UserDefaults.standard.data(forKey: profileKey),
           let profile = try? JSONDecoder().decode(BusinessProfile.self, from: profileData) {
            self.businessProfile = profile
        } else {
            self.businessProfile = BusinessProfile()
        }

        if let bidsData = UserDefaults.standard.data(forKey: bidsKey),
           let bids = try? JSONDecoder().decode([BidRequest].self, from: bidsData) {
            self.bidRequests = bids
        } else {
            self.bidRequests = BidRequest.sampleRequests
        }
    }

    func saveProfile() {
        if let data = try? JSONEncoder().encode(businessProfile) {
            UserDefaults.standard.set(data, forKey: profileKey)
        }
    }

    func saveBids() {
        if let data = try? JSONEncoder().encode(bidRequests) {
            UserDefaults.standard.set(data, forKey: bidsKey)
        }
    }

    func updateBidStatus(_ bid: BidRequest, status: BidStatus) {
        if let index = bidRequests.firstIndex(where: { $0.id == bid.id }) {
            bidRequests[index].status = status
            saveBids()
        }
    }

    func submitBidResponse(_ bid: BidRequest, response: BidResponse) {
        if let index = bidRequests.firstIndex(where: { $0.id == bid.id }) {
            bidRequests[index].bidResponse = response
            bidRequests[index].status = .quoted
            saveBids()
        }
    }

    func addBidRequest(_ bid: BidRequest) {
        bidRequests.insert(bid, at: 0)
        saveBids()
    }

    func deleteBidRequest(at offsets: IndexSet) {
        bidRequests.remove(atOffsets: offsets)
        saveBids()
    }

    var newBidCount: Int {
        bidRequests.filter { $0.status == .new }.count
    }
}
