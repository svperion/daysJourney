//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

// folder name counting starts with the outermost folder (parent of all)

private let fileManager = FileManager.default



func getFolderStructure(username: String, year: String, month: String, day: String) -> (filePath: URL, doesExist: Bool)? {
    let FIRST_FOLDER = "\(username).daysJourney"
    let SECOND_FOLDER = "\(username).allJourneys"
    let THIRD_FOLDER = "\(year).dj"
    let FOURTH_FOLDER = "\(month)_\(year).dj"
    let FINAL_FILE = "\(day)_\(month)_\(year)"

    let folderNames = [FIRST_FOLDER, SECOND_FOLDER, THIRD_FOLDER, FOURTH_FOLDER]

    if let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        var folderDir = URL(fileURLWithPath: documentDir.path)

        for folder in folderNames {
            folderDir = folderDir.appendingPathComponent(folder)
            checkAndMakeDir(filePath: folderDir)
        }

        let finalFilePath = folderDir.appendingPathComponent(FINAL_FILE).appendingPathExtension("json")

        if (doesFolderExist(filePath: finalFilePath)) {
            return (filePath: finalFilePath, doesExist: true)
        } else {
            return (filePath: finalFilePath, doesExist: false)
        }
    }
    return nil
}

private func checkAndMakeDir(filePath: URL) {
    if !doesFolderExist(filePath: filePath) {
        do {
            try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            checkAndMakeDir(filePath: filePath)
        }
    }
}

func doesFolderExist(filePath: URL) -> Bool {
    fileManager.fileExists(atPath: filePath.path)
}

func getDocumentsDirectory() -> [URL] {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

    return paths
}

