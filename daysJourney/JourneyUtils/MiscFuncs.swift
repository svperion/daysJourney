//
// Created by Orion Neguse on 2022-03-12.
//

import Foundation

// TODO: ADD VOICE RECORDING FUNCTIONALITY
// TODO: ADD PICTURE FUNCTIONALITY

func isStrBlank(text: String) -> Bool {
    let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return trimmed.isEmpty
}

func getStartingChars(written: String) -> String {

    let removeCharacters: Set<Character> = ["\n"]
    var smallWritten = written
    smallWritten.removeAll(where: { removeCharacters.contains($0) })

    let offset = 20
    if offset < smallWritten.endIndex.encodedOffset {
        let index1 = smallWritten.index(smallWritten.startIndex, offsetBy: offset)
        return String(smallWritten[..<index1]) + "..."
    } else {
        return smallWritten
    }

}




