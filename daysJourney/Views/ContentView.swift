//
//  ContentView.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @StateObject private var jViewModel = JournalViewModel()
    var body: some View {
        TabView {
            DaysPage()
                    .environmentObject(jViewModel)
                    .tabItem {
                        Image(systemName: "pencil.circle")
                        Text("Day")
                    }
            FavePage()
                    .tabItem {
                        Image(systemName: "heart.circle")
                        Text("Faves")
                    }
            AllPage()
                    .environmentObject(jViewModel)
                    .tabItem {
                        Image(systemName: "list.bullet.circle")
                        Text("All")
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
    @EnvironmentObject private var jViewModel: JournalViewModel
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack {
            DatedHeader(headerStr: "daysJourney", headerColor: Color.purple, alignment: Alignment.trailing, dateStr: jViewModel.currentDTFormats.dateStr)

            VStack {
                // TODO: IMPLEMENT BUTTON FUNCTIONS
                Button(action: { isFocused.toggle() }, label: {
                    Text(jViewModel.currentDTFormats.timeStr + ":")
                            .font(.body)
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                })
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                TextEditor(text: $jViewModel.currentWrite)
                        .font(.body)
                        .padding(.bottom)
                        .focused($isFocused)
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
            Button(action: {}) {
                Image(systemName: "plus")
                        .foregroundColor(.cyan)
                        .font(.body)
            }
        }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct AllPage: View {
    @EnvironmentObject var jViewModel: JournalViewModel
    @State private var isEditMode: EditMode = .inactive
    let dictJournals = realmSave.getAllJournalsAsTMs()
    @State var presentingModal = false
    var body: some View {
//        NavigationView {
        VStack {
//                HStack {
//                    Button(action: {
//                    }) {
//                        Image("cog_grey").renderingMode(.original)
//                    }
//                            .padding()
//                    TopHeader(headerStr: "allJourneys", headerColor: Color.blue, alignment: Alignment.trailing)
//                            .padding(.horizontal)
//                }
//
//                Button(action: {
//                    isEditMode = (isEditMode.isEditing ? .inactive : .active)
//                }, label: {
//                    Text("Select")
//                            .font(.body)
//                            .foregroundColor(.cyan)
//
//                })
//                        .padding(.horizontal)
//                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)

            List(selection: $jViewModel.allPageSelection) {
                ForEach(Array(dictJournals.keys), id: \.self) { key in
                    Section(header: Text(getDateAsString(key))) {
                        // If you wanted to iterate through each of the values in the keys, you can do the following: (transactionDate is the String key)
                        ForEach(dictJournals[key]!) { moment in
                            Button(action: { self.presentingModal = true }, label: {
                                HStack {
                                    Text(moment.time)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    Text(getStartingChars(written: moment.written))
                                            .font(.body)
                                            .foregroundColor(.black)
                                }
                            })
                                    .sheet(isPresented: $presentingModal) {
                                        JournalModal(oldDate: moment.date, oldTime: moment.time, oldJournal: moment.written)
                                    }
                        }
                    }
                }
            }
                    .listStyle(.grouped)
                    .toolbar {
                        EditButton()
                    }
                    .environment(\.editMode, $isEditMode)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
//        }
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)


    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
