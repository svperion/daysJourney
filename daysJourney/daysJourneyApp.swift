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
    let journalTuple = JournalSaver(dateJournal: date).getListOfJournalTime()
    let momentsJournal = journalTuple.moments

    var todayMenus = [TodayMenu]()
    for singleMoment in momentsJournal {
        todayMenus.append(getMomentsAsTodayMenu(moment: singleMoment, date: date))
    }
    return todayMenus
}

private func getMomentsAsTodayMenu(moment: MomentJournal, date: Date) -> TodayMenu {
    let datesTuple = getDateTimeData(date: date)
    return TodayMenu(id: String(moment.time), date: datesTuple.dateStr, time: datesTuple.timeStr, written: moment.written)
}

struct TodayMenu: Codable, Equatable, Identifiable{
    let id: String
    let date: String
    let time: String
    let written: String
}

