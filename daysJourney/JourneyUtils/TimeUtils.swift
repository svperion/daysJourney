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

struct DTFormats {
    let timeStr: String
    let dateStr: String
    let dateJournal: Date
}