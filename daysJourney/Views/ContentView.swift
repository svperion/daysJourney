//
//  ContentView.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @StateObject var jViewModel = JournalViewModel()
    @State var selection = 2
    var body: some View {

        NavigationView {
            TabView {
                DaysPage()
                        .environmentObject(jViewModel)
                        .tabItem {
                            Image("cog_grey")
                            Text("Day")
                        }
                FavePage()
                        .tabItem {
                            Image("cog_grey")
                            Text("Faves")
                        }
                AllPage()
                        .environmentObject(jViewModel)
                        .tabItem {
                            Image("cog_grey")
                            Text("All")
                        }
            }
        }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    realmSave.saveJournal(userWriting: jViewModel.currentWrite,
                            startTime: jViewModel.currentDTFormats.dateJournal)
                    print("Lost Focus")
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    print("Gain Focus \(Date().timeIntervalSince1970)")
                }
    }
}

// displays the current journal that the user is writing
struct DaysPage: View {
    @EnvironmentObject var jViewModel: JournalViewModel
    var body: some View {
        VStack {
            DatedHeader(headerStr: "daysJourney", headerColor: Color.purple, alignment: Alignment.trailing, dateStr: jViewModel.currentDTFormats.dateStr)

            VStack {
                // TODO: IMPLEMENT BUTTON FUNCTIONS
                Button(action: {}, label: {
                    Text(jViewModel.currentDTFormats.timeStr + ":")
                            .font(.body)
                            .foregroundColor(.gray)

                })
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                TextEditor(text: $jViewModel.currentWrite)
                        .font(.body)
                        .padding(.bottom)
            }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, maxHeight: 630, alignment: .leading)
        }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .padding(.horizontal)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
    }
}

struct AllPage: View {
    @EnvironmentObject var jViewModel: JournalViewModel
    let dictJournals = realmSave.getAllJournalsAsTMs()
    @State var presentingModal = false
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                }) {
                    Image("cog_grey").renderingMode(.original)
                }
                        .padding()
                TopHeader(headerStr: "allJourneys", headerColor: Color.cyan, alignment: Alignment.trailing)
                        .padding(.horizontal)
            }

            List {
                // TODO: FIX THE DATE ORDERS
                ForEach(Array(dictJournals.keys), id: \.self) { key in
                    Section(header: Text(getDateAsString(key))){
                        // If you wanted to iterate through each of the values in the keys, you can do the following: (transactionDate is the String key)
                        ForEach(dictJournals[key]!) { moment in
                            HStack{
                                Button(moment.time) {
                                    self.presentingModal = true
                                }
                                Text(getStartingChars(written: moment.written))
                            }

                                    .sheet(isPresented: $presentingModal) {
                                        JournalModal(oldDate: moment.date, oldTime: moment.time, oldJournal: moment.written)
                                    }
                        }
                    }
                }
            }
                    .listStyle(.insetGrouped)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        }
                .navigationBarTitle("allJourneys")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
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
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
