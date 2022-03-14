//
// Created by Orion Neguse on 2022-03-14.
//

import Foundation

class DefaultsHandler {
    private static let userDefaults: UserDefaults = UserDefaults.standard
    private static let KEY_LAST_OPEN = "lastOpened"
    private static let KEY_USERNAME = "username"
    private static let KEY_LOGGED_IN = "isLoggedIn"
    private static let KEY_TIME_TO_PASS = "timeToPass"

    // TODO: MAKE FUNCTIONS AND CLASS STATIC
    static func isLoggedIn() -> Bool {
        DefaultsHandler.userDefaults.bool(forKey: DefaultsHandler.KEY_LOGGED_IN)
    }

    static func logIn(_ username: String) {
        setUsername(username)
        setLoggedIn()
    }

    static func secsCanPass() -> Int {
        let secTimePass = DefaultsHandler.userDefaults.integer(forKey: DefaultsHandler.KEY_TIME_TO_PASS)
        if secTimePass > 0 {
            return secTimePass
        } else {
            setSecsToPass(600)
            return secsCanPass()
        }
    }

    static func setSecsToPass(_ secsToPass: Int) {
        if secsToPass >= 60 {
            DefaultsHandler.userDefaults.set(secsToPass, forKey: DefaultsHandler.KEY_TIME_TO_PASS)
        } else {
            setSecsToPass(60)
        }
    }

    private static func setLoggedIn() {
        DefaultsHandler.userDefaults.set(true, forKey: DefaultsHandler.KEY_LOGGED_IN)
    }

    private static func setUsername(_ username: String) {
        DefaultsHandler.userDefaults.set(username, forKey: DefaultsHandler.KEY_USERNAME)
    }

    static func getLastOpened() -> Date {
        let potentialDate = userDefaults.object(forKey: DefaultsHandler.KEY_LAST_OPEN)
        if potentialDate != nil {
            return potentialDate as! Date
        } else {
            setLastOpened(Date())
            return getLastOpened()
        }
    }

    static func setLastOpened(_ date: Date) {
        DefaultsHandler.userDefaults.set(date, forKey: DefaultsHandler.KEY_LAST_OPEN)
    }

    static func getUsername() -> String {
        DefaultsHandler.userDefaults.string(forKey: DefaultsHandler.KEY_USERNAME) ?? ""
    }
}