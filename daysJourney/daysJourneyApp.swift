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

func saveToJson(userWriting: String, timeUnix: Int){
    JsonUtility().makeCustomJson(userWriting:  userWriting, mTimeUnix: timeUnix);
}

func getSavedJournal() -> String {
    JsonUtility().readFromJson() ?? "Failed to get journal......"
}

