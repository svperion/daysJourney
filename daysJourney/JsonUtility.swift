//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

class JsonUtility {

    private let fileManager = FileManager.default

    private let mTimeUnix: Int

    private let mYear: String
    private let mMonth: String
    private let mDay: String

    init(timeUnix: Int) {
        mTimeUnix = timeUnix

        let dateStrs = getDateArray(timeUnix: timeUnix)

        mYear = dateStrs[0]
        mMonth = dateStrs[1]
        mDay = dateStrs[2]
    }



    func makeCustomJson(userWriting: String, timeUnix: Int) {
        // gets the appropriate folder path and whether a JSON already exists for the given date;
        // nil means some unknown error was encountered
        if let jsonPathExists = getFolderStructure(username: "orionneguse", year: "2022", month: "02", day: "22") {

            if jsonPathExists.doesExist {
                writeToExistingJson(filePath: jsonPathExists.filePath, userWriting: userWriting, timeUnix: timeUnix)
            } else {
                writeToNewJson(filePath: jsonPathExists.filePath, userWriting: userWriting, timeUnix: timeUnix)
            }

        } else {
            print("Failure to get/make folder structure")
        }
    }

    private func writeToNewJson(filePath: URL, userWriting: String, timeUnix: Int) {

        let jsonMoment = [MomentJournal(time: timeUnix, written: userWriting)]

        let jsonJournal = DaysJournal(date: "2022-02-22", journals: jsonMoment)

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

    private func writeToExistingJson(filePath: URL, userWriting: String, timeUnix: Int) {
        if var editJournal = getSaveAsCodable(filePath: filePath) {
            editJournal.journals.append(MomentJournal(time: timeUnix, written: userWriting))

            do {
                let data = try JSONEncoder().encode(editJournal)
                let journalString = String(data: data, encoding: .utf8)
                try journalString?.write(to: filePath, atomically: true, encoding: .utf8)
            } catch {

            }
        }
    }

//    func writeToJson() {
//
//        let jsonExample = getSampleJson()
//
//        if let jsonPath = getFolderStructure(username: "orionneguse", year: "2022", month: "02", day: "08")?.filePath {
//            do {
//                try jsonExample.write(to: jsonPath, atomically: true, encoding: .utf8)
//            } catch {
//                print("Failed to Write to Disk")
//            }
//        }
//
//    }

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

private func getDateArray(timeUnix: Int) -> [String]{
    let date = Date(timeIntervalSince1970: Double(timeUnix))
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateStr = formatter.string(from: date)

    return dateStr.components(separatedBy: "-")
}

func getCurrentTime() -> (timeStr: String, dateJournal: Date) {
    let thisMoment = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm:ss a"
    let timeStr = dateFormatter.string(from: thisMoment).lowercased()
    return (timeStr: timeStr, dateJournal: thisMoment)
}
