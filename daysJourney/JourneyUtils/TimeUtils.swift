//
// Created by Orion Neguse on 2022-03-12.
//

import Foundation

func getCurrentTime() -> DTFormats {
    getDateTimeData(date: Date())
}

func getDateTimeData(date: Date) -> DTFormats {
    let timeStr = getTimeAsString(time: date)
    let dateStr = getDateAsString(date: date)
    return DTFormats(timeStr: timeStr, dateStr: dateStr, dateJournal: date)
}

private func getDateAsString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EE, MMM dd, yyyy"
    return dateFormatter.string(from: date)
}

func getTimeAsString(time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: time).lowercased()
}

struct TimePass {
    static func muchTimePass() -> Bool {
        let lastOpened = Int(DefaultsHandler.getLastOpened().timeIntervalSince1970)
        let secsPassed = Int(Date().timeIntervalSince1970) - lastOpened
        let secsCanPass = DefaultsHandler.secsCanPass()

        return (secsPassed > secsCanPass)
    }

    private static func howMuchSecsPass(since: Int, to: Int) -> Int {
        to - since
    }

    private static func howMuchMinPass(time: Int) -> Int {
        (time / 60)
    }
}

func getDateAsColTuple(dateJournal: Date) -> (dateStrArray: [String], dateStr: String) {
    let dateStr = getDateAsHyphSep(dateJournal: dateJournal)
    return (dateStr.components(separatedBy: "-"), dateStr)
}

func getDateAsString(_ dateStr: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.date(from: dateStr)!
    return getDateAsString(date: date)
}

func getDateAsHyphSep(dateJournal: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: dateJournal)
}

struct DTFormats {
    let timeStr: String
    let dateStr: String
    let dateJournal: Date
}

