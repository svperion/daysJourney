//
//  ContentView.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

private let currentTimeTuple = getCurrentTime()

struct ContentView: View {

    @State private var selection = 3
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
            CalendarPage()
                    .tag(4)
        }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
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

            VStack {
                Text("daysJourney")
                        .font(.title)
                        .foregroundColor(.purple)
                        .padding(.bottom, 10)


                Button(action: {}, label: {
                    Text(currentTimeTuple.dateStr + " >")
                            .font(.headline)
                            .foregroundColor(.gray)
                })
            }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom)


            VStack {
                Button(action: {}, label: {
                    Text(currentTimeTuple.timeStr + ":")
                            .font(.body)
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                })


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
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, maxHeight: 630, alignment: .topLeading)


        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct DayPage: View {

    var body: some View {
        VStack {

            VStack {
                Text("todaysJourney")
                        .font(.title)
                        .foregroundColor(.pink)
                        .padding(.bottom, 10)


                Button(action: {}, label: {
                    Text(currentTimeTuple.dateStr)
                            .font(.headline)
                            .foregroundColor(.gray)
                })
            }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom)


        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct CalendarPage: View {
    var body: some View {
        VStack {

        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
