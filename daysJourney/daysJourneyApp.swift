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

func getAllJournalTime(date: Date) -> [TodayMenu] {
    let journalTimes = JournalSaver(dateJournal: date).getListOfJournalTime()
    var todayMenus = [TodayMenu]()
    for singleTime in journalTimes {
        todayMenus.append(TodayMenu(id: singleTime))
    }
    return todayMenus
}

struct TodayMenu: Codable, Equatable, Identifiable{
    let id: String
}

