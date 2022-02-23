//
// Created by Orion Neguse on 2022-02-23.
//

import Foundation
private let fileManager = FileManager.default

//func getAllJournalsFolder(username: String) -> (doesExist: Bool, filePath: URL) {
//    let FIRST_FOLDER = "\(username).daysJourney"
//    let SECOND_FOLDER = "\(username).allJourneys"
//    let FINAL_FILE = "allJournals"
//
//    if let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//        let filePath = documentDir.appendingPathComponent(FIRST_FOLDER)
//        if doesFolderExist(filePath: filePath) {
//            let secondPath = filePath.appendingPathComponent(SECOND_FOLDER)
//            if doesFolderExist(filePath: secondPath) {
//                let finalPath = secondPath.appendingPathComponent(FINAL_FILE).appendingPathExtension("json")
//
//                if doesFolderExist(filePath: finalPath) {
//                    return (doesExist: true, filePath: finalPath)
//                } else {
//                    return (doesExist: false, filePath: finalPath)
//                }
//            } else {
//                do {
//                    try fileManager.createDirectory(atPath: secondPath.path, withIntermediateDirectories: true, attributes: nil)
//                } catch {
//
//                }
//                let finalPath = secondPath.appendingPathComponent(FINAL_FILE).appendingPathExtension("json")
//
//                if doesFolderExist(filePath: finalPath) {
//                    return (doesExist: true, filePath: finalPath)
//                } else {
//                    return (doesExist: false, filePath: finalPath)
//                }
//            }
//        } else {
//            do {
//                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
//            } catch {
//
//            }
//        }
//        print("Document directory is \(filePath)")
//    }
//}

