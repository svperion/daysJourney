//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

class AllJournalSaver {
    fileprivate let fileManager = FileManager.default
    fileprivate let mTimeUnix: Int

    fileprivate let mJournalPath: URL
    fileprivate let mJournalExists: Bool
    fileprivate let mFileSuccess: Bool

    fileprivate let mFolderManager: FolderManager

    required internal init(dateJournal: Date, folderManager: FolderManager) {
        mTimeUnix = Int(dateJournal.timeIntervalSince1970)
        mFolderManager = folderManager

        if let jsonPathExists = mFolderManager.getJournalFiles() {
            mJournalPath = jsonPathExists.filePath
            mJournalExists = jsonPathExists.doesExist
            mFileSuccess = true
        } else {
            mJournalPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            mJournalExists = false
            mFileSuccess = false
        }
    }

    convenience init() {
        self.init(dateJournal: Date(), folderManager: FolderManager())
    }

    private func addToAllJournals() throws {
//        if mFileSuccess {
//            do {
//                let allJournals = AllJournalsCoda(userName: <#T##String##Swift.String#>, allJournals: <#T##[EachJournalsCoda]##[daysJourney.JournalSaver.EachJournalsCoda]#>)
//                let data = try JSONEncoder().encode(allJournals)
//                let allJournalStr = String(data: data, encoding: .utf8)
//                try allJournalStr?.write(to: mJournalPath, atomically: true, encoding: .utf8)
//
//            } catch {
//                print("Failed to Write to Disk")
//            }
//
//        }
    }

    private func writeToExistAllJournals() {

    }

    private struct AllJournalsCoda: Codable {
        let userName: String
        let allJournals: [EachJournalsCoda]
    }

    private struct EachJournalsCoda: Codable {
        let time: Int
        let writtenHint: String
    }

}

class JournalSaver: AllJournalSaver {

    private let mUserName: String = DefaultsHandler.getUsername()
    private let mYear: String, mMonth: String, mDay: String, mFullDate: String

    required init(dateJournal: Date, folderManager: FolderManager) {
        let dates = getDateAsColTuple(dateJournal: dateJournal)
        mYear = dates.dateStrArray[0]
        mMonth = dates.dateStrArray[1]
        mDay = dates.dateStrArray[2]

        mFullDate = dates.dateStr
        super.init(dateJournal: dateJournal,
                folderManager: FolderManager(username: mUserName, year: mYear, month: mMonth, day: mDay))
    }

    convenience init(dateJournal: Date) {
        self.init(dateJournal: dateJournal,
                folderManager: FolderManager())
    }

    func getListOfJournalTime() -> (timeStrs: [String], moments: [MomentJournalCoda]) {
        var listOfTimes = [String]()
        if let moments: [MomentJournalCoda] = getMomentsCodable(filePath: mJournalPath) {
            for singleMoment in moments {
                let time = Date(timeIntervalSince1970: Double(singleMoment.time))
                listOfTimes.append(getTimeAsString(time: time))
            }
            return (timeStrs: listOfTimes, moments: moments)
        }
        return (timeStrs: ["Failed"], moments: [MomentJournalCoda(time: 0, written: "")])
    }

    func readJournalFromDisk() {

    }

    func saveJournalToDisk(userWriting: String) {
        // gets the appropriate folder path and whether a JSON already exists for the given date;
        // nil means some unknown error was encountered
        if doesJournalExist() {
            writeToExistingJournal(filePath: mJournalPath, userWriting: userWriting)
        } else if mFileSuccess {
            writeToNewJournal(filePath: mJournalPath, userWriting: userWriting)
        }

    }

    private func writeToExistingJournal(filePath: URL, userWriting: String) {
        if var editJournal = getJournalCodable(filePath: filePath) {
            editJournal.journals.append(MomentJournalCoda(time: mTimeUnix, written: userWriting))

            writeToDisk(filePath: filePath, daysJournal: editJournal)
        }
    }

    private func writeToNewJournal(filePath: URL, userWriting: String) {

        let newMoments = [MomentJournalCoda(time: mTimeUnix, written: userWriting)]
        let newJournal = DaysJournalCoda(date: mFullDate, journals: newMoments)

        writeToDisk(filePath: filePath, daysJournal: newJournal)
    }

    private func writeToDisk(filePath: URL, daysJournal: DaysJournalCoda) {
        do {
            let data = try JSONEncoder().encode(daysJournal)
            let journalString = String(data: data, encoding: .utf8)
            try journalString?.write(to: filePath, atomically: true, encoding: .utf8)

        } catch {
            print("Failed to Write to Disk")
        }
    }

    private func getSingleMoment(filePath: URL, timeUnix: Int) -> MomentJournalCoda? {
        if let moments = getMomentsCodable(filePath: filePath) {
            for singleMoment in moments {
                if (singleMoment.time == timeUnix) {
                    return singleMoment
                }
            }
        }
        return nil
    }

    private func getMomentsCodable(filePath: URL) -> [MomentJournalCoda]? {
        if let daysJournal: DaysJournalCoda = getJournalCodable(filePath: filePath) {
            return daysJournal.journals
        }
        return nil
    }

    private func getJournalCodable(filePath: URL) -> DaysJournalCoda? {
        do {
            let savedData = try Data(contentsOf: filePath)
            let savedJournal: DaysJournalCoda = try JSONDecoder().decode(DaysJournalCoda.self, from: savedData)
            return savedJournal
        } catch {
            return nil
        }
    }

    private func doesJournalExist() -> Bool {
        mFileSuccess && mJournalExists
    }

    private struct DaysJournalCoda: Codable {
        let date: String
        var journals: [MomentJournalCoda]
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

struct MomentJournalCoda: Codable {
    let time: Int
    let written: String
}




