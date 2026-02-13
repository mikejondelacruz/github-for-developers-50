import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingGooglePreview = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Google Business Profile", systemImage: "building.2.fill")
                            .font(.headline)
                        Text("Fill in your business details below. This information will be used to create and manage your Google Business Profile listing.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Business Information") {
                    TextField("Business Name", text: $dataStore.businessProfile.businessName)
                        .textContentType(.organizationName)
                    TextField("Owner Name", text: $dataStore.businessProfile.ownerName)
                        .textContentType(.name)
                    TextField("Phone Number", text: $dataStore.businessProfile.phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $dataStore.businessProfile.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Website (optional)", text: $dataStore.businessProfile.website)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                }

                Section("Address") {
                    TextField("Street Address", text: $dataStore.businessProfile.address)
                        .textContentType(.streetAddressLine1)
                    TextField("City", text: $dataStore.businessProfile.city)
                        .textContentType(.addressCity)
                    TextField("State", text: $dataStore.businessProfile.state)
                        .textContentType(.addressState)
                    TextField("ZIP Code", text: $dataStore.businessProfile.zipCode)
                        .textContentType(.postalCode)
                        .keyboardType(.numberPad)
                }

                Section("Business Description") {
                    TextEditor(text: $dataStore.businessProfile.description)
                        .frame(minHeight: 80)
                }

                Section("Services Offered") {
                    NavigationLink("Manage Services (\(dataStore.businessProfile.servicesOffered.count))") {
                        ServiceSelectionView()
                    }
                }

                Section("Business Hours") {
                    NavigationLink("Set Hours") {
                        BusinessHoursView()
                    }
                }

                Section {
                    Button(action: {
                        dataStore.saveProfile()
                        showingGooglePreview = true
                    }) {
                        HStack {
                            Spacer()
                            Label("Preview Google Business Profile", systemImage: "eye.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!dataStore.businessProfile.isProfileComplete)

                    Button(action: {
                        dataStore.saveProfile()
                    }) {
                        HStack {
                            Spacer()
                            Label("Save Profile", systemImage: "square.and.arrow.down")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Business Profile")
            .sheet(isPresented: $showingGooglePreview) {
                GoogleProfilePreview()
            }
        }
    }
}
