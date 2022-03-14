//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

class FolderManager {
    private let fileManager = FileManager.default

    // folder name counting starts with the outermost folder (parent of all)
    private let mFolderNames: [String]
    private let mFinalFile: String

    // used to check or create a daily journal file
    init(username: String, year: String, month: String, day: String) {
        let FIRST_FOLDER = "allJournals.daysJourney"
        let SECOND_FOLDER = "allJournals.daysJourney"
        let THIRD_FOLDER = "\(year).dj"
        let FOURTH_FOLDER = "\(month)_\(year).dj"

        mFinalFile = "\(day)_\(month)_\(year).json"
        mFolderNames = [FIRST_FOLDER, SECOND_FOLDER, THIRD_FOLDER, FOURTH_FOLDER]
    }

    // used to check or create the allJournals file
    init() {
        let FIRST_FOLDER = "allJournals.daysJourney"
        let SECOND_FOLDER = "allJournals.daysJourney"
        mFinalFile = "allJournals.json"

        mFolderNames = [FIRST_FOLDER, SECOND_FOLDER]
    }

    func getJournalFiles() -> (filePath: URL, doesExist: Bool)? {
        checkFile(folderNames: mFolderNames, fileName: mFinalFile)
    }

    private func checkFile(folderNames: [String], fileName: String) -> (filePath: URL, doesExist: Bool)? {
        if let folderDir = checkFolders(folderNames: folderNames) {
            let finalFilePath = folderDir.appendingPathComponent(fileName)

            if (FolderManager.doesFolderExist(filePath: finalFilePath)) {
                return (filePath: finalFilePath, doesExist: true)
            } else {
                return (filePath: finalFilePath, doesExist: false)
            }
        }
        return nil
    }

    private func checkFolders(folderNames: [String]) -> URL? {

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
        if !FolderManager.doesFolderExist(filePath: filePath) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                checkAndMakeDir(filePath: filePath)
            }
        }
    }

    static func doesFolderExist(filePath: URL) -> Bool {
        FileManager.default.fileExists(atPath: filePath.path)
    }

    static func getDocumentsDirectory() -> [URL] {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths
    }

}






