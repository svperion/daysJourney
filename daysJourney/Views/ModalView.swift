//
// Created by Orion Neguse on 2022-03-12.
//

import SwiftUI

struct JournalModal: View {
    let oldDate: String
    let oldTime: String
    let oldJournal: String

    var body: some View {
        VStack {
            VStack {
                Text(oldDate)
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .padding(.top)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                Text(oldTime)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.vertical)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)

            ScrollView {
                VStack {
                    Text(oldJournal)
                            .font(.body)
                }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)

            }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)

        }
                .padding(.horizontal)
    }
}

struct SettingsModal: View {

    var body: some View {
        Text("Settings")

    }
}

struct CalendarModal: View {

    @State var dateSel = Date()

    var body: some View {
        VStack {
            Text("Please Select a Date")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            DatePicker("Date", selection: $dateSel)
                    .datePickerStyle(.graphical)

        }
                .padding(10)


    }
}