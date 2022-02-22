//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

class JournalSaver {

    private let fileManager = FileManager.default

    private let mTimeUnix: Int

    private let mUserName: String = "orionneguse"
    private let mYear: String, mMonth: String, mDay: String,  mFullDate: String

    init(dateJournal: Date) {
        mTimeUnix = Int(dateJournal.timeIntervalSince1970)

        let dates = getDateAsString(dateJournal: dateJournal)
        mYear = dates.dateStrArray[0]
        mMonth = dates.dateStrArray[1]
        mDay = dates.dateStrArray[2]

        mFullDate = dates.dateStr
    }

    func readJournalFromDisk() -> (){

    }

    func saveJournalToDisk(userWriting: String) {
        // gets the appropriate folder path and whether a JSON already exists for the given date;
        // nil means some unknown error was encountered
        if let jsonPathExists = getFolderStructure(username: mUserName, year: mYear, month: mMonth, day: mDay) {
            if jsonPathExists.doesExist {
                writeToExistingJson(filePath: jsonPathExists.filePath, userWriting: userWriting)
            } else {
                writeToNewJson(filePath: jsonPathExists.filePath, userWriting: userWriting)
            }

        } else {
            print("Failure to get/make folder structure")
        }
    }

    private func writeToNewJson(filePath: URL, userWriting: String) {

        let jsonMoment = [MomentJournal(time: mTimeUnix, written: userWriting)]

        let jsonJournal = DaysJournal(date: mFullDate, journals: jsonMoment)

        do {
            let data = try JSONEncoder().encode(jsonJournal)
            let journalString = String(data: data, encoding: .utf8)

            do {
                try journalString?.write(to: filePath, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to Write to Disk")
            }
        } catch {

        }

    }

    private func writeToExistingJson(filePath: URL, userWriting: String) {
        if var editJournal = getSaveAsCodable(filePath: filePath) {
            editJournal.journals.append(MomentJournal(time: mTimeUnix, written: userWriting))

            do {
                let data = try JSONEncoder().encode(editJournal)
                let journalString = String(data: data, encoding: .utf8)
                try journalString?.write(to: filePath, atomically: true, encoding: .utf8)
            } catch {

            }
        }
    }

    private func getSaveAsCodable(filePath: URL) -> DaysJournal? {
        do {
            let savedData = try Data(contentsOf: filePath)
            let savedJournal: DaysJournal = try JSONDecoder().decode(DaysJournal.self, from: savedData)
            return savedJournal
        } catch {
            return nil
        }
    }

    private struct DaysJournal: Codable {
        let date: String
        var journals: [MomentJournal]
    }

    private struct MomentJournal: Codable {
        let time: Int
        let written: String
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

private func getDateAsString(dateJournal: Date) -> (dateStrArray: [String], dateStr: String){
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateStr = formatter.string(from: dateJournal)
    return (dateStr.components(separatedBy: "-"), dateStr)
}

func getCurrentTime() -> (timeStr: String, dateStr: String, dateJournal: Date) {
    let thisMoment = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm:ss a"
    let timeStr = dateFormatter.string(from: thisMoment).lowercased()
    dateFormatter.dateFormat = "EE, MMM dd, yyyy"
    let dateStr = dateFormatter.string(from: thisMoment)
    return (timeStr: timeStr, dateStr: dateStr, dateJournal: thisMoment)
}
