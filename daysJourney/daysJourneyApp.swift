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

func readFromJson() -> String?{
    parse(jsonData: readLocalFile(forName: "08_02_2022") ?? Data())
}

private func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                ofType: "json"),
           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
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


        print("reading.....")
        print("===================================")
        return "Title: " + decodedData.date
    } catch {
        print("decode error")
    }
    return nil
}

struct DaysJournal: Codable {
    let date: String
    let journals: [MomentJournal]
}

struct MomentJournal: Codable {
    let time: UInt
    let written: String
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
