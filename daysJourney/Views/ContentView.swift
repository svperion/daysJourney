//
//  ContentView.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

private let currentDTFormats = getCurrentTime()



struct ContentView: View {
    @StateObject var jViewModel = JournalViewModel()
    @State var selection = 2
    var body: some View {

        TabView(selection: $selection) {

                AllPage()
                        .tag(0)
                FavePage()
                        .tag(1)
                DaysPage()
                        .environmentObject(jViewModel)
                        .tag(2)
                TodayPage()
                        .tag(3)


        }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    saveToDisk(userWriting: jViewModel.currentWrite, date: currentDTFormats.dateJournal)
                    print("Lost Focus")
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    print("Gain Focus")
                }
    }
}

struct AllPage: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: {}) {
                    Image("cog_grey").renderingMode(.original)
                }
                        .padding()
                TopHeader(headerStr: "allJourneys", headerColor: Color.cyan, alignment: Alignment.trailing)
            }

        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct FavePage: View {
    var body: some View {
        VStack {
            HStack {
                TopHeader(headerStr: "faveJourneys", headerColor: Color.red, alignment: Alignment.leading)
                Button(action: {}) {
                    Image("cog_grey").renderingMode(.original)
                }
                        .padding()
            }
        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

// displays the current journal that the user is writing
struct DaysPage: View {
    @EnvironmentObject var jViewModel: JournalViewModel

    var body: some View {
        VStack {

            DatedHeader(headerStr: "daysJourney", headerColor: Color.purple, alignment: Alignment.trailing,
                    dateStr: currentDTFormats.dateStr)

            VStack {
                Button(action: {}, label: {
                    Text(currentDTFormats.timeStr + ":")
                            .font(.body)
                            .foregroundColor(.gray)

                })
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)


                TextEditor(text: $jViewModel.currentWrite)
                        .font(.body)
                        .padding(.bottom, 35)
            }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, maxHeight: 630, alignment: .leading)
        }
                .padding(.horizontal)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
    }
}

// displays all the journals from the same day
struct TodayPage: View {
    @EnvironmentObject private var observeModel: LogInViewModel
    let daysJournalTimes = getAllJournalTime(date: currentDTFormats.dateJournal)
    @State var presentingModal = false
    var body: some View {
        VStack {
            DatedHeader(headerStr: "todaysJourney", headerColor: Color.green, alignment: Alignment.leading,
                    dateStr: currentDTFormats.dateStr)
                    .padding(.horizontal)

            List {
                ForEach(daysJournalTimes) { moment in
                    Button(moment.time) {
                        self.presentingModal = true
                    }
                            .sheet(isPresented: $presentingModal) {
                                JournalModal(oldDate: moment.date, oldTime: moment.time, oldJournal: moment.written)
                            }
                }

            }
                    .listStyle(.plain)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
