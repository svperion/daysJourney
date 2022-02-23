//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

class JournalSaver {

    private let fileManager = FileManager.default

    private let mTimeUnix: Int

    private let mUserName: String = "orionneguse"
    private let mYear: String, mMonth: String, mDay: String, mFullDate: String

    private let mJournalPath: URL
    private let mJournalExists: Bool
    private let mFileSuccess: Bool

    init(dateJournal: Date) {
        mTimeUnix = Int(dateJournal.timeIntervalSince1970)

        let dates = getDateAsString(dateJournal: dateJournal)
        mYear = dates.dateStrArray[0]
        mMonth = dates.dateStrArray[1]
        mDay = dates.dateStrArray[2]

        mFullDate = dates.dateStr

        if let jsonPathExists = FolderManager(username: "nineerrr", year: "2012", month: "11", day: "23")
                .getJourneysStructure() {
            mJournalPath = jsonPathExists.filePath
            mJournalExists = jsonPathExists.doesExist
            mFileSuccess = true
        } else {
            mJournalPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            mJournalExists = false
            mFileSuccess = false
        }

    }

    func getListOfJournalTime() -> (timeStrs: [String], moments: [MomentJournal] ){
        var listOfTimes = [String]()
        if let moments: [MomentJournal] = getMomentsCodable(filePath: mJournalPath){
            for singleMoment in moments {
                let time = Date(timeIntervalSince1970: Double(singleMoment.time))
                listOfTimes.append(getTimeAsString(time: time))
            }
            return (timeStrs: listOfTimes, moments: moments)
        }
        return (timeStrs: ["Failed"], moments: [MomentJournal(time: 0, written: "")])
    }

    func readJournalFromDisk() {

    }

    func saveJournalToDisk(userWriting: String) {
        // gets the appropriate folder path and whether a JSON already exists for the given date;
        // nil means some unknown error was encountered
        if doesJournalExist() {
            writeToExistingJson(filePath: mJournalPath, userWriting: userWriting)
        } else if mFileSuccess {
            writeToNewJson(filePath: mJournalPath, userWriting: userWriting)
        }

    }


    private func writeToNewJson(filePath: URL, userWriting: String) {

        let newMoment = [MomentJournal(time: mTimeUnix, written: userWriting)]
        let newJournal = DaysJournal(date: mFullDate, journals: newMoment)

        writeToDisk(filePath: filePath, daysJournal: newJournal)
    }

    private func writeToExistingJson(filePath: URL, userWriting: String) {
        if var editJournal = getJournalCodable(filePath: filePath) {
            editJournal.journals.append(MomentJournal(time: mTimeUnix, written: userWriting))

            writeToDisk(filePath: filePath, daysJournal: editJournal)
        }
    }

    private func writeToDisk(filePath: URL, daysJournal: DaysJournal) {

        do {
            let data = try JSONEncoder().encode(daysJournal)
            let journalString = String(data: data, encoding: .utf8)
            try journalString?.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to Write to Disk")
        }
    }

    private func getSingleMoment(filePath: URL, timeUnix: Int) -> MomentJournal? {
        if let moments = getMomentsCodable(filePath: filePath){
            for singleMoment in moments {
                if (singleMoment.time == timeUnix){
                    return singleMoment
                }
            }
        }
        return nil
    }

    private func getMomentsCodable(filePath: URL) -> [MomentJournal]? {
        if let daysJournal: DaysJournal = getJournalCodable(filePath: filePath) {
            return daysJournal.journals
        }
        return nil
    }

    private func getJournalCodable(filePath: URL) -> DaysJournal? {
        do {
            let savedData = try Data(contentsOf: filePath)
            let savedJournal: DaysJournal = try JSONDecoder().decode(DaysJournal.self, from: savedData)
            return savedJournal
        } catch {
            return nil
        }
    }

    private func doesJournalExist() -> Bool {
        mFileSuccess && mJournalExists
    }

    private struct DaysJournal: Codable {
        let date: String
        var journals: [MomentJournal]
    }

    private struct AllJournal: Codable {
        let userName: String
        let allJournals: [Int]
    }

    private func getSampleJson() -> String {
        """
        {\n  \"date\": \"2022-02-08\",\n  \"journals\": [\n    {\n      \"time\": 1645172408,\n      \"written\": 
        \"My day was just awesome! Wow man\"\n    },\n    {\n      \"time\": 1645182708,\n      \"written\": 
        \"Cool things! Yes\"\n    },\n    {\n      \"time\": 1655192729,\n      \"written\": 
        \"Coolio dude! Let's do it!\"\n    }\n  ]\n}
        """
    }
}

struct MomentJournal: Codable {
    let time: Int
    let written: String
}

private func getDateAsString(dateJournal: Date) -> (dateStrArray: [String], dateStr: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateStr = formatter.string(from: dateJournal)
    return (dateStr.components(separatedBy: "-"), dateStr)
}

func getCurrentTime() -> (timeStr: String, dateStr: String, dateJournal: Date) {
    getDateTimeData(date: Date())
}

func getDateTimeData(date: Date) -> (timeStr: String, dateStr: String, dateJournal: Date){
    let timeStr = getTimeAsString(time: date)
    let dateStr = getDateAsString(date: date)
    return (timeStr: timeStr, dateStr: dateStr, dateJournal: date)
}

private func getDateAsString(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EE, MMM dd, yyyy"
    return dateFormatter.string(from: date)
}

private func getTimeAsString(time: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm:ss a"
    return dateFormatter.string(from: time).lowercased()
}
