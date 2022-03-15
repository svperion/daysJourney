//
// Created by Orion Neguse on 2022-03-12.
//

import Foundation

let realmSave: RealmSave = RealmSave()


class LogInViewModel: ObservableObject {
    @Published var isLoggedIn: Bool

    init() {
        print(NSHomeDirectory())
        isLoggedIn = DefaultsHandler.isLoggedIn()
    }

    func logIn(username: String) {
        DefaultsHandler.logIn(username)
        isLoggedIn = true
    }
}

class JournalViewModel: ObservableObject {

    @Published var currentWrite: String
    let currentDTFormats: DTFormats
    // holds the user's current writing
    let currentTuple = realmSave.startFromMoment()

    init() {
        currentWrite = currentTuple.currentWrite
        currentDTFormats = currentTuple.timeData
        print(realmSave.getAllJournalsAsTMs())
    }
}

struct AllDaysMenu: Codable, Equatable, Identifiable {
    let id: String
    let date: String
    let time: String
    let written: String
}






