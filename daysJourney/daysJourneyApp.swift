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
//                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//                        print("Lost Focus")
//                    }
//                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
//                        print("Gain Focus")
//                    }

        }
    }
}


func saveToDisk(userWriting: String, date: Date) {
    print(NSHomeDirectory())
    JournalSaver(dateJournal: date).saveJournalToDisk(userWriting: userWriting);
}

func getAllJournalTime(date: Date) -> [TodayMenu] {
    let journalTuple = JournalSaver(dateJournal: date).getListOfJournalTime()
    let momentsJournal = journalTuple.moments

    var todayMenus = [TodayMenu]()
    for singleMoment in momentsJournal {
        todayMenus.append(getMomentsAsTodayMenu(moment: singleMoment, date: date))
    }
    return todayMenus
}

private func getMomentsAsTodayMenu(moment: MomentJournalCoda, date: Date) -> TodayMenu {
    let datesTuple = getDateTimeData(date: date)
    return TodayMenu(id: String(moment.time), date: datesTuple.dateStr, time: datesTuple.timeStr, written: moment.written)
}

struct TodayMenu: Codable, Equatable, Identifiable {
    let id: String
    let date: String
    let time: String
    let written: String
}

class ObserveModel: ObservableObject {
    // holds the user's current writing
    @Published var currentWrite = "Changing Stuff"

    init(){

    }


}

