//
// Created by Orion Neguse on 2022-03-13.
//

import Foundation
import RealmSwift

// TODO: ADD FAVE FUNCTION WITH CUSTOM FOLDERS/CATEGORIES

// TODO: ADD BUTTON THAT ALLOWS USER TO WRITE A NEW MOMENT WHEN EXISTING ONE IS CHOSEN

class RealmSave {
    // Open the local-only default realm
    private let mLocalRealm: Realm
    private let isMomentContinue: Bool
    private let mAllJournalTasks: Results<JournalsTask>

    init() {
        isMomentContinue = !TimePass.muchTimePass()
        mLocalRealm = try! Realm(fileURL: getRealmUrl())
        mAllJournalTasks = mLocalRealm.objects(JournalsTask.self)
    }

    func saveJournal(userWriting: String, startTime: Date) {
        // checks if journal entry is blank
        if !isStrBlank(text: userWriting) {
            print("Works")
            // current time and also the end time for the current moment
            let endTime = Date()
            // journal task from current day; nil if task/data doesn't exist
            let journalTask = getCurrentJournal(date: endTime)
            writeToJournal(startTime: startTime, endTime: endTime, userWriting: userWriting, journalTask: journalTask)
        }
    }

    private func writeToJournal(startTime: Date, endTime: Date, userWriting: String, journalTask: JournalsTask?) {
        if journalTask == nil {
            writeToNewJournal(startTime: startTime, endTime: endTime, userWriting: userWriting)
        } else if isMomentContinue {
            writeToExistingMoment(startTime: startTime, endTime: endTime, userWriting: userWriting,
                    journalTask: journalTask!)
        } else {
            writeToNewMoment(startTime: startTime, endTime: endTime, userWriting: userWriting,
                    journalTask: journalTask!)
        }
    }

    private func writeToExistingMoment(startTime: Date, endTime: Date, userWriting: String, journalTask: JournalsTask) {
        let momentTask = journalTask.momentsTask.first {
            $0.endTime == Int(DefaultsHandler.getLastOpened().timeIntervalSince1970)
        }
        try! mLocalRealm.write {
            momentTask!.written = userWriting
        }
    }

    private func writeToNewMoment(startTime: Date, endTime: Date, userWriting: String, journalTask: JournalsTask) {
        try! mLocalRealm.write {
            let newMoment = MomentsTask(time: Int(startTime.timeIntervalSince1970),
                    endTime: Int(endTime.timeIntervalSince1970), written: userWriting)
            journalTask.momentsTask.append(newMoment)
        }
    }

    private func getCurrentJournal(date: Date) -> JournalsTask? {
        mAllJournalTasks.first {
            // finds a journal for current day; format is yyyy-MM-dd
            $0.date.contains(getDateAsHyphSep(dateJournal: date))
        }
    }

    private func writeToNewJournal(startTime: Date, endTime: Date, userWriting: String) {
        let momentsList = List<MomentsTask>()

        let newMomentTask = MomentsTask(time: Int(startTime.timeIntervalSince1970),
                endTime: Int(endTime.timeIntervalSince1970), written: userWriting)
        momentsList.append(newMomentTask)

        let journalsTask = JournalsTask(date: getDateAsHyphSep(dateJournal: startTime), momentsList: momentsList)
        try! mLocalRealm.write {
            mLocalRealm.add(journalsTask)
        }
    }

//    func readCurrentJournal() -> (written: String, time: Int) {
//
//    }

    func readRealm() {
        // You can also filter a collection
        let tasksThatBeginWithA = mAllJournalTasks.where {
            $0.momentsTask.written.starts(with: "A")
        }
        print("A list of all tasks that begin with A: \(tasksThatBeginWithA.first?.momentsTask)")
    }

    private func doesLastMomentExist() -> Bool {
        doesMomentExist(dateTime: DefaultsHandler.getLastOpened())
    }

    private func doesMomentExist(dateTime: Date) -> Bool {
        // You can also filter a collection
        let journalTask = mAllJournalTasks.first {
            let results = $0.momentsTask.where { (moment: Query<MomentsTask>) -> Query<Bool> in
                moment.endTime == Int(dateTime.timeIntervalSince1970)
            }
            return !results.isEmpty
        }
        return journalTask != nil
    }
}

private func getRealmUrl() -> URL {
    let finalDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return finalDir.appendingPathComponent("daysJourney").appendingPathExtension("realm")
}


class JournalsTask: Object {
    @Persisted(primaryKey: true) var date: String
    @Persisted var momentsTask: List<MomentsTask>

    convenience init(date: String, momentsList: List<MomentsTask>) {
        self.init()
        self.date = date
        momentsTask = momentsList
    }
}

class MomentsTask: Object {
    @Persisted(primaryKey: true) var time: Int
    @Persisted var endTime: Int
    @Persisted var written: String

    convenience init(time: Int, endTime: Int, written: String) {
        self.init()
        self.time = time
        self.written = written
    }
}