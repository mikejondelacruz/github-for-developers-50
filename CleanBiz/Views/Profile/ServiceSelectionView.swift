import SwiftUI

struct ServiceSelectionView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingCustomService = false
    @State private var customName = ""
    @State private var customDescription = ""
    @State private var customPrice = ""

    var body: some View {
        List {
            Section("Suggested Services") {
                ForEach(CleaningService.suggestions) { service in
                    let isSelected = dataStore.businessProfile.servicesOffered.contains(where: { $0.name == service.name })

                    Button(action: {
                        toggleService(service)
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(service.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(service.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("Starting at $\(service.basePrice, specifier: "%.0f")")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                            Spacer()
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(isSelected ? .green : .secondary)
                                .font(.title3)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            if !dataStore.businessProfile.servicesOffered.filter({ service in
                !CleaningService.suggestions.contains(where: { $0.name == service.name })
            }).isEmpty {
                Section("Custom Services") {
                    ForEach(dataStore.businessProfile.servicesOffered.filter({ service in
                        !CleaningService.suggestions.contains(where: { $0.name == service.name })
                    })) { service in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(service.name).font(.subheadline).fontWeight(.medium)
                                Text(service.description).font(.caption).foregroundStyle(.secondary)
                                Text("Starting at $\(service.basePrice, specifier: "%.0f")").font(.caption).foregroundStyle(.green)
                            }
                            Spacer()
                            Button(action: {
                                dataStore.businessProfile.servicesOffered.removeAll(where: { $0.id == service.id })
                                dataStore.saveProfile()
                            }) {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }

            Section {
                Button(action: { showingCustomService = true }) {
                    Label("Add Custom Service", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("Services")
        .alert("Add Custom Service", isPresented: $showingCustomService) {
            TextField("Service Name", text: $customName)
            TextField("Description", text: $customDescription)
            TextField("Base Price", text: $customPrice)
                .keyboardType(.decimalPad)
            Button("Add") {
                if let price = Double(customPrice), !customName.isEmpty {
                    let service = CleaningService(name: customName, description: customDescription, basePrice: price)
                    dataStore.businessProfile.servicesOffered.append(service)
                    dataStore.saveProfile()
                    customName = ""
                    customDescription = ""
                    customPrice = ""
                }
            }
            Button("Cancel", role: .cancel) {
                customName = ""
                customDescription = ""
                customPrice = ""
            }
        }
    }

    private func toggleService(_ service: CleaningService) {
        if let index = dataStore.businessProfile.servicesOffered.firstIndex(where: { $0.name == service.name }) {
            dataStore.businessProfile.servicesOffered.remove(at: index)
        } else {
            dataStore.businessProfile.servicesOffered.append(service)
        }
        dataStore.saveProfile()
    }
}
