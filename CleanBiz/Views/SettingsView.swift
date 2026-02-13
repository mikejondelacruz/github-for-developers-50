import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingResetAlert = false
    @State private var notificationsEnabled = true
    @State private var autoReplyEnabled = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        VStack(alignment: .leading) {
                            Text(dataStore.businessProfile.businessName.isEmpty ? "Not Set Up" : dataStore.businessProfile.businessName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(dataStore.businessProfile.email.isEmpty ? "No email" : dataStore.businessProfile.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Notifications") {
                    Toggle("Push Notifications", isOn: $notificationsEnabled)
                    Toggle("Auto-Reply to New Bids", isOn: $autoReplyEnabled)
                }

                Section("Google Business Profile") {
                    NavigationLink("Manage Profile") {
                        ProfileSetupView()
                    }

                    Button(action: {}) {
                        Label("Open Google Business Dashboard", systemImage: "arrow.up.right.square")
                    }

                    Button(action: {}) {
                        Label("Sync Profile with Google", systemImage: "arrow.triangle.2.circlepath")
                    }
                }

                Section("Data") {
                    HStack {
                        Text("Total Bids")
                        Spacer()
                        Text("\(dataStore.bidRequests.count)")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Services Listed")
                        Spacer()
                        Text("\(dataStore.businessProfile.servicesOffered.count)")
                            .foregroundStyle(.secondary)
                    }

                    Button(action: { showingResetAlert = true }) {
                        Label("Reset Sample Data", systemImage: "arrow.counterclockwise")
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Data", isPresented: $showingResetAlert) {
                Button("Reset", role: .destructive) {
                    dataStore.bidRequests = BidRequest.sampleRequests
                    dataStore.saveBids()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset bid requests to sample data. Your business profile will not be affected.")
            }
        }
    }
}
