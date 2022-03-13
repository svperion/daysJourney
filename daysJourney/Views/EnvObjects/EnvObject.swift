//
// Created by Orion Neguse on 2022-03-12.
//

import Foundation

class LogInViewModel: ObservableObject {
    @Published var isLoggedIn: Bool
    let defaultHandler = DefaultsHandler()

    init() {
        print(NSHomeDirectory())
        isLoggedIn = defaultHandler.isLoggedIn()
    }

    func logIn(username: String) {
        defaultHandler.logIn(username)
        isLoggedIn = true
    }
}

class JournalViewModel: ObservableObject {
    // holds the user's current writing
    @Published var currentWrite = ""

}

func isStrBlank(text: String) -> Bool {
    let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return trimmed.isEmpty
}




