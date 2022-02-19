//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

class JsonUtility {

//    private let journalDir: URL
    private let fileManager = FileManager.default

    init() {

    }

    func writeToJson() {

        let jsonExample = getSampleJson()


        if let jsonPath = getFolderStructure(username: "orionneguse", year: "2022", month: "02", day: "08") {
            do {
                try jsonExample.write(to: jsonPath, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to Write to Disk")
            }
        }


    }

    func readFromJson() -> String? {
        parse(jsonData: readLocalFile() ?? Data())
    }

    private func readLocalFile() -> Data? {
        do {
            let documentDir = getDocumentsDirectory()[0]
            if let fileUrl = getFolderStructure(username: "orionneguse", year: "2022", month: "02", day: "08") {
                // Get the saved data
                let savedData = try Data(contentsOf: fileUrl)
                // Convert the data back into a string
                return savedData
                if let savedString = String(data: savedData, encoding: .utf8) {
                    print(savedString)
                }
            }

        } catch {
            print(error)
        }

        return nil
    }

    private func parse(jsonData: Data) -> String? {
        do {
            let decodedData = try JSONDecoder().decode(DaysJournal.self,
                    from: jsonData)

            return decodedData.date
        } catch {
            print("decode error")
        }
        return nil
    }

    private struct DaysJournal: Codable {
        let date: String
        let journals: [MomentJournal]
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

func getCurrentTime() -> String {
    let today = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm:ss a"
    return dateFormatter.string(from: today).lowercased()
}