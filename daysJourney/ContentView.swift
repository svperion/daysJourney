//
//  ContentView.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

struct ContentView: View {
    @State private var currentIndex = 0
    private let colors: [Color] = [.red, .blue, .green, .yellow]

    var body: some View {

        TabView() {
            Text("First")
            MainPage()
            Text("Third")
        }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}


struct MainPage: View {
    @State var currentWrite = "Changing Stuff";
    var body: some View {

        VStack {

            VStack {
                Text("daysJourney")
                        .font(.title)
                        .foregroundColor(.purple)
                        .padding(.bottom, 10)


                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Sun, Jan 30, 2022 >")
                            .font(.headline)
                            .foregroundColor(.gray)
                })
            }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom)

            ScrollView {
                VStack {
                    Text("7:52 pm:")
                            .font(.body)
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                    TextEditor(text: $currentWrite)
                            .font(.body)

                }
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)

            }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 500, maxHeight: 550, alignment: .topLeading)


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
