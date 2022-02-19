//
//  daysJourneyApp.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

@main
struct daysJourneyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func readFromJson() -> String? {
    let jsonData = readLocalJSONFile(forName: "08_02_2022")
    if let data = jsonData {
        if let sampleRecordObj = parse(jsonData: data) {
            //You can read sampleRecordObj just like below.
            print("users list: \(sampleRecordObj.date)")
//            print("firstName:\(sampleRecordObj.date.first?.date ?? "")")
            return sampleRecordObj.date
        }
    }
    return nil
}

func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}

func parse(jsonData: Data) -> user? {
    do {
        let decodedData = try JSONDecoder().decode(user.self, from: jsonData)
        return decodedData
    } catch {
        print("error: \(error)")
    }
    return nil
}

struct user: Codable {
    let date: String
    let journals: String
}


func writeToJson() {

    let jsonExample = getSampleJson()

    if let documentDir = getDocumentsDirectory().first {
        let jsonPath = documentDir.appendingPathComponent("08_02_2022.json")
        do {
            try jsonExample.write(to: jsonPath, atomically: true, encoding: .utf8)
            print(NSHomeDirectory())
        } catch {
            print("Failed to Write to Disk")
        }
    }

}

func getCurrentTime() -> String {
    let today = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm:ss a"
    return dateFormatter.string(from: today).lowercased()
}

func getDocumentsDirectory() -> [URL] {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    return paths
}

private func getSampleJson() -> String {
    """
    {\n  \"date\": \"2022-02-08\",\n  \"journals\": [\n    {\n      \"time\": 1645172408,\n      \"written\": 
    \"My day was just awesome! Wow man\"\n    },\n    {\n      \"time\": 1645182708,\n      \"written\": 
    \"Cool things! Yes\"\n    },\n    {\n      \"time\": 1655192729,\n      \"written\": 
    \"Coolio dude! Let's do it!\"\n    }\n  ]\n}
    """
}

struct DemoData: Codable {
    let title: String
    let description: String
}
