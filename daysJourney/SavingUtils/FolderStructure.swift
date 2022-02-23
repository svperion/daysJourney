//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

// folder name counting starts with the outermost folder (parent of all)

private let fileManager = FileManager.default

class FolderManager {
    let FIRST_FOLDER: String
    let SECOND_FOLDER: String
    let THIRD_FOLDER: String
    let FOURTH_FOLDER: String
    let FINAL_FILE: String

    init(username: String, year: String, month: String, day: String){
        FIRST_FOLDER = "\(username).daysJourney"
        SECOND_FOLDER = "\(username).allJourneys"
        THIRD_FOLDER = "\(year).dj"
        FOURTH_FOLDER = "\(month)_\(year).dj"
        FINAL_FILE = "\(day)_\(month)_\(year).json"
    }

    init(username: String){
        FIRST_FOLDER = "\(username).daysJourney"
        SECOND_FOLDER = "\(username).allJourneys"
        FINAL_FILE = "allJournals.json"

        THIRD_FOLDER = ""
        FOURTH_FOLDER = ""
    }

    func getAllJournalFolder() -> (filePath: URL, doesExist: Bool)? {
        let folderNames = [FIRST_FOLDER, SECOND_FOLDER]
        return checkFile(folderNames: folderNames, fileName: FINAL_FILE)
    }

    func getJourneysStructure() -> (filePath: URL, doesExist: Bool)? {
        let folderNames = [FIRST_FOLDER, SECOND_FOLDER, THIRD_FOLDER, FOURTH_FOLDER]
        return checkFile(folderNames: folderNames, fileName: FINAL_FILE)
    }

    private func checkFile(folderNames: [String], fileName: String) -> (filePath: URL, doesExist: Bool)? {
        if let folderDir = checkFolders(folderNames: folderNames){
            let finalFilePath = folderDir.appendingPathComponent(fileName)

            if (doesFolderExist(filePath: finalFilePath)) {
                return (filePath: finalFilePath, doesExist: true)
            } else {
                return (filePath: finalFilePath, doesExist: false)
            }
        }
        return nil
    }

    private func checkFolders(folderNames: [String]) -> URL?{

        if let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            var folderDir = URL(fileURLWithPath: documentDir.path)

            for folder in folderNames {
                folderDir = folderDir.appendingPathComponent(folder)
                checkAndMakeDir(filePath: folderDir)
            }

            return folderDir
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

}


func doesFolderExist(filePath: URL) -> Bool {
    fileManager.fileExists(atPath: filePath.path)
}

func getDocumentsDirectory() -> [URL] {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

    return paths
}

