//
// Created by Orion Neguse on 2022-03-13.
//

import Foundation
import RealmSwift

class JournalsTask: Object {
    @Persisted(primaryKey: true) var date: String
    @Persisted var momentsTask: List<MomentsTask>

    convenience init(date: String, momentsTask: List<MomentsTask>) {
        self.init()
        self.date = date
        self.momentsTask = momentsTask
    }
}

class MomentsTask: Object {
    @Persisted(primaryKey: true) var time: Int
    @Persisted var endTime: Int
    @Persisted var written: String

    convenience init(time: Int, written: String) {
        self.init()
        self.time = time
        self.written = written
    }
}

// Open the local-only default realm
private let localRealm = try! Realm(fileURL: getRealmUrl())
private let journalTasks = localRealm.objects(JournalsTask.self)


func modifyRealm() {
    // All modifications to a realm must happen in a write block.
    let taskToUpdate = journalTasks[0]
    try! localRealm.write {
        taskToUpdate.momentsTask.first?.written = "InProgress"
    }
}

func readRealm() {
    // You can also filter a collection
    let tasksThatBeginWithA = journalTasks.where {
        $0.momentsTask.written.starts(with: "Work")
    }
    print("A list of all tasks that begin with A: \(tasksThatBeginWithA.first?.date ?? "")")
}

func writeRealm() {
    DispatchQueue.main.async {

        let task = MomentsTask(time: 02166025119, written: "Working")
        let list = List<MomentsTask>()
        list.append(task)
        let task1 = JournalsTask(date: "24-62-2022", momentsTask: list)

        do {

            try localRealm.write {
                localRealm.add(task1)
            }
        } catch {
            print("Failed")
        }
    }
}

func getRealmUrl() -> URL {
    let finalDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return finalDir.appendingPathComponent("daysJourney").appendingPathExtension("realm")
}

