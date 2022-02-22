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

func saveToDisk(userWriting: String, date: Date){
    JournalSaver(dateJournal: date).saveJournalToDisk(userWriting: userWriting);
}

//func getSavedJournal(date: Date) -> String {
//    JsonUtility(dateJournal: date).readFromJson() ?? "Failed to get journal......"
//}

