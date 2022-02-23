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
            AllPage()
                    .tag(0)
            FavePage()
                    .tag(1)
            DaysPage()
                    .tag(2)
            TodayPage()
                    .tag(3)

        }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct AllPage: View {
    var body: some View {
        VStack {
            HStack{
                Button(action: {}){
                    Image("cog_grey").renderingMode(.original)
                }.padding()
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
            HStack{
                TopHeader(headerStr: "faveJourneys", headerColor: Color.red, alignment: Alignment.leading)
                Button(action: {}){
                    Image("cog_grey").renderingMode(.original)
                }.padding()
            }
        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct DaysPage: View {
    @State var currentWrite = "Changing Stuff"
    @FocusState var textEditorFocus: Bool

    var body: some View {
        VStack {

            DatedHeader(headerStr: "daysJourney", headerColor: Color.purple, alignment: Alignment.trailing)

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

// displays all the journals from the same day
struct TodayPage: View {
    let daysJournalTimes = getAllJournalTime(date: currentTimeTuple.dateJournal)
    @State var presentingModal = false
    var body: some View {
        VStack {

            DatedHeader(headerStr: "todaysJourney", headerColor: Color.green, alignment: Alignment.leading)
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

        }.padding(10)


    }
}

private struct DatedHeader: View {
    let headerStr: String
    let headerColor: Color
    let alignment: Alignment

    @State var presentingModal = false

    var body: some View {
        VStack {
            TopHeader(headerStr: headerStr, headerColor: headerColor, alignment: alignment)

            Button(currentTimeTuple.dateStr + " >") {
                self.presentingModal = true
            }
                    .sheet(isPresented: $presentingModal) {
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

private struct TopHeader: View {
    let headerStr: String
    let headerColor: Color
    let alignment: Alignment

    var body: some View {
        Text(headerStr)
                .font(.largeTitle)
                .foregroundColor(headerColor)
                .padding(.bottom, 10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
