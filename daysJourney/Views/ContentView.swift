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
                        Image(systemName: "square.and.pencil")
                        Text("Day")
                    }
            FavePage()
                    .environmentObject(jViewModel)
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Faves")
                    }
            AllPage()
                    .environmentObject(jViewModel)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("All")
                    }
        }
                .accentColor(.purple)

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
                .padding(.horizontal)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
    }
}

struct FavePage: View {
    @EnvironmentObject var jViewModel: JournalViewModel

    private let dictJournals = realmSave.getAllJournalsAsTMs()

    @State private var presentingModal = false
    @State private var isEditMode: EditMode = .inactive
    @State private var selBtnStr: String = "Select"

    var body: some View {
        NavigationView {
            VStack {
                List(selection: $jViewModel.allPageSelection) {
                    ForEach(Array(dictJournals.keys), id: \.self) { key in
                        Section(header: Text(getDateAsString(key))) {
                            // If you wanted to iterate through each of the values in the keys, you can do the following: (transactionDate is the String key)
                            ForEach(dictJournals[key]!) { moment in
                                Button(action: { self.presentingModal = true }, label: {
                                    HStack {
                                        Text(moment.time)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        Text(getStartingChars(written: moment.written))
                                                .font(.body)
                                                .foregroundColor(.secondary)
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
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Button(action: {
                                    if !isEditMode.isEditing {
                                        isEditMode = .active
                                        selBtnStr = "Done"
                                    } else {
                                        isEditMode = .inactive
                                        selBtnStr = "Select"
                                    }

                                }, label: {
                                    Text(selBtnStr)
                                            .foregroundColor(.red)
                                })

                                Menu {
                                    Text("Hola")
                                } label: {
                                    Image(systemName: "circle.grid.2x2")
                                            .foregroundColor(.red)
                                }
                            }
                        }
                        .environment(\.editMode, $isEditMode)

            }
                    .navigationBarTitle("faveJourneys")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)

        }
    }
}

struct AllPage: View {
    @EnvironmentObject var jViewModel: JournalViewModel

    private let dictJournals = realmSave.getAllJournalsAsTMs()

    @State private var presentingModal = false
    @State private var isEditMode: EditMode = .inactive
    @State private var selBtnStr: String = "Select"
    @State private var searchStr: String = ""

    private let mAccColor = Color.orange

    var body: some View {
        NavigationView {
            VStack {

                List(selection: $jViewModel.allPageSelection) {
                    ForEach(Array(dictJournals.keys), id: \.self) { key in
                        Section(header: Text(getDateAsString(key))) {
                            // If you wanted to iterate through each of the values in the keys, you can do the following: (transactionDate is the String key)
                            ForEach(dictJournals[key]!) { moment in
                                Button(action: { self.presentingModal = true }, label: {
                                    HStack {
                                        Text(moment.time)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        Text(getStartingChars(written: moment.written))
                                                .font(.body)
                                                .foregroundColor(.secondary)
                                    }
                                })
                                        .sheet(isPresented: $presentingModal) {
                                            JournalModal(oldDate: moment.date, oldTime: moment.time, oldJournal: moment.written)
                                        }
                            }
                        }
                    }
                }
                        //TODO: IMPLEMENT SEARCH FUNCTION
                        .accentColor(mAccColor)
                        .searchable(text: $searchStr)
                        .listStyle(.grouped)
                        .toolbar {
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button(action: {
                                    if !isEditMode.isEditing {
                                        isEditMode = .active
                                        selBtnStr = "Done"
                                    } else {
                                        isEditMode = .inactive
                                        selBtnStr = "Select"
                                        jViewModel.allPageSelection.removeAll()
                                    }
                                }, label: {
                                    Text(selBtnStr).foregroundColor(mAccColor)
                                })

                                Menu {
                                    Button(action: {
                                        // TODO: IMPLEMENT MODAL THAT ADDS TO favePage
                                        if !isEditMode.isEditing {
                                            isEditMode = .active
                                            selBtnStr = "Done"
                                        } else {
                                            isEditMode = .inactive
                                            selBtnStr = "Select"
                                        }
                                    }, label: {
                                        Image(systemName: "square.and.arrow.up").foregroundColor(mAccColor)
                                    })
                                } label: {
                                    Image(systemName: "circle.grid.2x2").foregroundColor(mAccColor)
                                }
                                        .accentColor(mAccColor)
                            }
                        }
                        .environment(\.editMode, $isEditMode)
            }
                    .navigationBarTitle("allJourneys")
                    .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
