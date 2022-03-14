//
// Created by Orion Neguse on 2022-03-12.
//

import Foundation

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
    // holds the user's current writing
    @Published var currentWrite = ""
    var realmSave: RealmSave?

    func initializeRealm() {
        realmSave = RealmSave()
    }

//        DefaultsHandler.setLastOpened(endTime)
}






