//
// Created by Orion Neguse on 2022-02-19.
//

import Foundation

// folder name counting starts with the outermost folder (parent of all)

private let fileManager = FileManager.default

func getFolderStructure(username: String, year: String, month: String, day: String) -> URL? {
    let FIRST_FOLDER = "\(username).daysJourney"

    if let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let filePath = documentDir.appendingPathComponent(FIRST_FOLDER)
        if doesFolderExist(filePath: filePath) {
            return getSecondFolder(username: username, year: year, month: month, day: day, filePath: filePath)
        } else {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                return getSecondFolder(username: username, year: year, month: month, day: day, filePath: filePath)
            } catch {

            }
        }
        print("Document directory is \(filePath)")
    }

    return nil
}

private func getSecondFolder(username: String, year: String, month: String, day: String, filePath: URL) -> URL? {
    let SECOND_FOLDER = "\(username).allJourneys"
    let secondPath = filePath.appendingPathComponent(SECOND_FOLDER)

    if doesFolderExist(filePath: secondPath) {
        return getThirdFolder(year: year, month: month, day: day, filePath: secondPath)
    } else {
        do {
            try fileManager.createDirectory(atPath: secondPath.path, withIntermediateDirectories: true, attributes: nil)
            return getThirdFolder(year: year, month: month, day: day, filePath: secondPath)
        } catch {

        }
    }

    return nil
}

private func getThirdFolder(year: String, month: String, day: String, filePath: URL) -> URL? {
    let THIRD_FOLDER = "\(year).dj"
    let thirdPath = filePath.appendingPathComponent(THIRD_FOLDER)

    if doesFolderExist(filePath: thirdPath) {
        return getFourthFolder(year: year, month: month, day: day, filePath: thirdPath)
    } else {
        do {
            try fileManager.createDirectory(atPath: thirdPath.path, withIntermediateDirectories: true, attributes: nil)
            return getFourthFolder(year: year, month: month, day: day, filePath: thirdPath)
        } catch {

        }
    }
    return nil
}

private func getFourthFolder(year: String, month: String, day: String, filePath: URL) -> URL? {
    let FOURTH_FOLDER = "\(month)_\(year).dj"
    let fourthPath = filePath.appendingPathComponent(FOURTH_FOLDER)

    if doesFolderExist(filePath: fourthPath) {
        return getFinalFile(year: year, month: month, day: day, filePath: fourthPath)
    } else {
        do {
            try fileManager.createDirectory(atPath: fourthPath.path, withIntermediateDirectories: true, attributes: nil)
            return getFinalFile(year: year, month: month, day: day, filePath: fourthPath)
        } catch {

        }
    }
    return nil
}

private func getFinalFile(year: String, month: String, day: String, filePath: URL) -> URL? {
    let FINAL_FILE = "\(day)_\(month)_\(year)"
    let finalPath = filePath.appendingPathComponent(FINAL_FILE).appendingPathExtension("json")

    if doesFolderExist(filePath: finalPath) {
        return finalPath
    } else {
        return finalPath

    }
}

private func doesFolderExist(filePath: URL) -> Bool {
    fileManager.fileExists(atPath: filePath.path)
}

func getDocumentsDirectory() -> [URL] {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

    return paths
}

