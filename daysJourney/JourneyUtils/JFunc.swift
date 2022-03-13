//
// Created by Orion Neguse on 2022-03-12.
//

import Foundation

func saveToDisk(userWriting: String, date: Date) {
    if !isStrBlank(text: userWriting) {
        JournalSaver(dateJournal: date).saveJournalToDisk(userWriting: userWriting)
    }
    print(NSHomeDirectory())
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

class DefaultsHandler {
    private let userDefaults: UserDefaults = UserDefaults.standard
    private let KEY_LAST_OPEN = "lastOpened"
    private let KEY_USERNAME = "username"
    private let KEY_LOGGED_IN = "isLoggedIn"

    func isLoggedIn() -> Bool {
        userDefaults.bool(forKey: KEY_LOGGED_IN)
    }

    func logIn(_ username: String) {
        setUsername(username)
        setLoggedIn()
    }

    private func setLoggedIn() {
        userDefaults.set(true, forKey: KEY_LOGGED_IN)
    }

    private func setUsername(_ username: String) {
        userDefaults.set(username, forKey: KEY_USERNAME)
    }

    func getLastOpened() -> Date? {
        userDefaults.object(forKey: KEY_LOGGED_IN) as! Date?
    }

    func setNowLastOpened(){
        setLastOpened(Date())
    }

    func setLastOpened(_ date: Date) {
        userDefaults.set(date, forKey: KEY_LAST_OPEN)
    }

    func getUsername() -> String {
        userDefaults.string(forKey: KEY_USERNAME) ?? ""
    }
}