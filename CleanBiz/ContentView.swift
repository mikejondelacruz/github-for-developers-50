import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            BidListView()
                .tabItem {
                    Label("Bids", systemImage: "doc.text.fill")
                }
                .badge(dataStore.newBidCount)

            ProfileSetupView()
                .tabItem {
                    Label("Profile", systemImage: "building.2.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Color.accentColor)
    }
}
