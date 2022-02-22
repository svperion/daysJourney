//
//  ContentView.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

struct ContentView: View {

    @State private var selection = 2

    var body: some View {
        
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
    @State var currentWrite = "Changing Stuff"
    var body: some View {
        VStack {

        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct FavouritesPage: View {
    @State var currentWrite = "Changing Stuff"
    var body: some View {
        VStack {

        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct MainPage: View {
    @State var currentWrite = "Changing Stuff"
    let currentTimeTuple = getCurrentTime()

    var body: some View {
        VStack {

            VStack {
                Text("daysJourney")
                        .font(.title)
                        .foregroundColor(.purple)
                        .padding(.bottom, 10)


                Button(action: {saveToJson(userWriting: currentWrite)}, label: {
                    Text("Sun, Jan 30, 2022 >")
                            .font(.headline)
                            .foregroundColor(.gray)
                })
            }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom)


            VStack {
                Button(action: {currentWrite = getSavedJournal()}, label: {
                    Text(currentTimeTuple.timeStr + ":")
                            .font(.body)
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                })


                TextEditor(text: $currentWrite)
                        .font(.body)
                        .padding(.bottom, 35)


            }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, maxHeight: 630, alignment: .topLeading)


        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal)
    }
}

struct DayPage: View {
    @State var currentWrite = "Changing Stuff"
    var body: some View {
        NavigationView {
            List {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }.navigationTitle("todaysJourney")
        }
                
    }
}

struct CalendarPage: View {
    @State var currentWrite = "Changing Stuff"
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
