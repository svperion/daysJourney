//
//  ContentView.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

private let currentTimeTuple = getCurrentTime()

struct ContentView: View {

    @State var selection = 2
    var body: some View {

//        let sceneDel = UISceneDelegate()
//        sceneDel.sceneWillResignActive{
//
//        }
        TabView(selection: $selection) {
            SettingsPage()
                    .tag(0)
            FavouritesPage()
                    .tag(1)
            MainPage()
                    .tag(2)
            DayPage()
                    .tag(3)

        }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct SettingsPage: View {
    var body: some View {
        VStack {

        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct FavouritesPage: View {
    var body: some View {
        VStack {

        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct MainPage: View {
    @State var currentWrite = "Changing Stuff"
    @FocusState var textEditorFocus: Bool

    var body: some View {
        VStack {

            TopHeader(headerStr: "daysJourney", headerColor: Color.purple, alignment: Alignment.trailing)

            VStack {
                Button(action: {}, label: {
                    Text(currentTimeTuple.timeStr + ":")
                            .font(.body)
                            .foregroundColor(.gray)

                })
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)


                TextEditor(text: $currentWrite)
                        .font(.body)
                        .padding(.bottom, 35)
                        .focused($textEditorFocus)
                        .onChange(of: textEditorFocus) { textEditorFocus in
                            if !textEditorFocus {
                                saveToDisk(userWriting: currentWrite, date: currentTimeTuple.dateJournal)
                            }
                        }
            }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, maxHeight: 630, alignment: .leading)


        }
                .padding(.horizontal)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
    }
}

struct DayPage: View {
    let daysJournalTimes = getAllJournalTime(date: currentTimeTuple.dateJournal)
    @State var presentingModal = false
    var body: some View {
        VStack {

            TopHeader(headerStr: "todaysJourney", headerColor: Color.pink, alignment: Alignment.leading)
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

struct CalendarModal: View {

    var body: some View {
        Text("")
        DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
    }
}

private struct TopHeader: View {
    let headerStr: String
    let headerColor: Color
    let alignment: Alignment

    @State var presentingModal = false

    var body: some View {
        VStack {
            Text(headerStr)
                    .font(.largeTitle)
                    .foregroundColor(headerColor)
                    .padding(.bottom, 10)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)

            Button(currentTimeTuple.dateStr + " >") {
                self.presentingModal = true
            }.sheet(isPresented: $presentingModal) {
                        CalendarModal()
                    }
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
        }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
