//
// Created by Orion Neguse on 2022-03-13.
//

import Foundation
import OrderedCollections
import RealmSwift

// TODO: ADD FAVE FUNCTION WITH CUSTOM FOLDERS/CATEGORIES
// TODO: ADD A SEARCH FUNCTIONALITY
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
            // the current time (also the end time for the current moment)
            let endTime = Date()
            // journal task from current day; nil if task/data doesn't exist
            let journalTask = getSavedJournal(date: endTime)
            writeToJournal(startTime: startTime, endTime: endTime, userWriting: userWriting, journalTask: journalTask)

            DefaultsHandler.setLastOpened(endTime)
        }
    }

    private func writeToJournal(startTime: Date, endTime: Date, userWriting: String, journalTask: JournalsTask?) {
        if journalTask == nil {
            writeToNewJournal(startTime: startTime, endTime: endTime, userWriting: userWriting)
        } else if isMomentContinue {
            writeToExistingMoment(endTime: endTime, userWriting: userWriting,
                    journalTask: journalTask!)
        } else {
            writeNewMoment(startTime: startTime, endTime: endTime, userWriting: userWriting,
                    journalTask: journalTask!)
        }
    }

    private func writeToExistingMoment(endTime: Date, userWriting: String, journalTask: JournalsTask) {
        let momentTask = journalTask.momentsTask.first {
            $0.endTime == Int(DefaultsHandler.getLastOpened().timeIntervalSince1970)
        }
        try! mLocalRealm.write {
            momentTask!.written = userWriting
            momentTask!.endTime = Int(endTime.timeIntervalSince1970)
        }
    }

    private func writeNewMoment(startTime: Date, endTime: Date, userWriting: String, journalTask: JournalsTask) {
        if !doesMomentExist(dateTime: startTime) {
            try! mLocalRealm.write {
                let newMoment = MomentsTask(time: Int(startTime.timeIntervalSince1970),
                        endTime: Int(endTime.timeIntervalSince1970), written: userWriting)
                journalTask.momentsTask.append(newMoment)
            }
        } else {
            writeToExistingMoment(endTime: endTime, userWriting: userWriting, journalTask: journalTask)
        }
    }

    private func getCurrentMoment() -> MomentsTask? {

        if isMomentContinue {
            return getSavedMoment(dateTime: DefaultsHandler.getLastOpened())
        } else {
            return nil
        }

    }

    private func getSavedMoment(dateTime: Date) -> MomentsTask? {
        let journalTask = getSavedJournal(date: dateTime)
        let momentTask = journalTask?.momentsTask.first {
            $0.endTime == Int(dateTime.timeIntervalSince1970)
        }
        return momentTask
    }

    private func getSavedJournal(date: Date) -> JournalsTask? {
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

    func getAllJournalsAsTMs() -> OrderedDictionary<String, [AllDaysMenu]> {
        var dictJournals: OrderedDictionary = OrderedDictionary<String, [AllDaysMenu]>()
        for journalTask in mAllJournalTasks {
            let dateStr = journalTask.date
            dictJournals[dateStr] = getMomentsAsADArray(journalTask: journalTask)
        }
        return dictJournals
    }

    func getAllMomentsAsTMs() -> [AllDaysMenu] {
        var todayMenus = [AllDaysMenu]()
        let allMomentsTasks = mLocalRealm.objects(MomentsTask.self)
        for momentTask in allMomentsTasks {
            todayMenus.append(getMomentAsADMenu(momentTask: momentTask))
        }
        return todayMenus
    }

    private func getMomentsAsADArray(journalTask: JournalsTask) -> [AllDaysMenu]{
        var todayMenus = [AllDaysMenu]()
        for momentTask in journalTask.momentsTask {
            todayMenus.append(getMomentAsADMenu(momentTask: momentTask))
        }
        return todayMenus
    }

    private func getMomentAsADMenu(momentTask: MomentsTask) -> AllDaysMenu {
        let allTimeDate = getDateTimeData(
                date: Date(timeIntervalSince1970: TimeInterval(momentTask.time)))
        let id = "\(momentTask.time)"
        let date = allTimeDate.dateStr
        let time = allTimeDate.timeStr
        let written = momentTask.written
        return AllDaysMenu(id: id, date: date, time: time, written: written)
    }

    func startFromMoment() -> (timeData: DTFormats, currentWrite: String) {
        // You can also filter a collection
        if let currentMoment = getCurrentMoment() {
            let date = Date(timeIntervalSince1970: Double(currentMoment.time))
            let timeData = getDateTimeData(date: date)
            let written = currentMoment.written
            return (timeData: timeData, currentWrite: written)
        } else {
            let timeData = getCurrentTime()
            return (timeData: timeData, currentWrite: "")
        }

    }

    private func doesLastMomentExist() -> Bool {
        doesMomentExist(dateTime: DefaultsHandler.getLastOpened())
    }

    private func doesMomentExist(dateTime: Date) -> Bool {
        // You can also filter a collection
        let momentTask = mLocalRealm.objects(MomentsTask.self).first {
            $0.time == Int(dateTime.timeIntervalSince1970)
        }
        return momentTask != nil
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
        self.endTime = endTime
        self.written = written
    }
}