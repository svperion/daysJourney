//
// Created by Orion Neguse on 2022-03-12.
//

import Foundation

// TODO: ADD VOICE RECORDING FUNCTIONALITY
// TODO: ADD PICTURE FUNCTIONALITY

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

func isStrBlank(text: String) -> Bool {
    let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return trimmed.isEmpty
}




