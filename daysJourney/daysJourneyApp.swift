//
//  daysJourneyApp.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

@main
struct daysJourneyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func saveToJson(userWriting: String, date: Date){
    JsonUtility(dateJournal: date).makeCustomJson(userWriting: userWriting);
}

//func getSavedJournal(date: Date) -> String {
//    JsonUtility(dateJournal: date).readFromJson() ?? "Failed to get journal......"
//}

