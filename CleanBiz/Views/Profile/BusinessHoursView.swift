import SwiftUI

struct BusinessHoursView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        List {
            ForEach($dataStore.businessProfile.businessHours) { $day in
                VStack(alignment: .leading, spacing: 8) {
                    Toggle(day.dayName, isOn: $day.isOpen)
                        .fontWeight(.medium)

                    if day.isOpen {
                        HStack {
                            DatePicker("Open", selection: $day.openTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            Text("to")
                                .foregroundStyle(.secondary)
                            DatePicker("Close", selection: $day.closeTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        .font(.subheadline)
                    } else {
                        Text("Closed")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Business Hours")
        .onDisappear {
            dataStore.saveProfile()
        }
    }
}
