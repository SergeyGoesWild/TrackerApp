//
//  CoreDataLayer.swift
//  Tracker
//
//  Created by Sergey Telnov on 05/12/2024.
//

import Foundation
import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createTracker(_ tracker: Tracker) -> TrackerCoreData {
        let newTracker = TrackerCoreData(context: context)
        newTracker.trackerID = tracker.trackerID
        newTracker.trackerName = tracker.trackerName
        newTracker.emoji = tracker.emoji
        newTracker.color = uiColorMarshalling.hexString(from: tracker.color)
        if let schedule = tracker.schedule {
            for unitString in schedule {
                let scheduleUnit = ScheduleUnit(context: context)
                scheduleUnit.value = unitString
                scheduleUnit.tracker = newTracker
            }
        }
        saveContext()
        return newTracker
    }
    
    func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerID == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Ошибка при получении трекера по ID: \(error)")
            return nil
        }
    }
    
    func convertToTracker(_ trackerCD: TrackerCoreData) -> Tracker {
        if let scheduleSet = trackerCD.schedule as? Set<ScheduleUnit> {
            let newSchedule = scheduleSet.compactMap { $0.value }
            let newTracker = Tracker(trackerID: trackerCD.trackerID ?? UUID(),
                                     trackerName: trackerCD.trackerName ?? "default",
                                     color: uiColorMarshalling.color(from: trackerCD.color ?? "#FFFFF"),
                                     emoji: trackerCD.emoji ?? "x",
                                     schedule: newSchedule)
            return newTracker
        } else {
            let newTracker = Tracker(trackerID: trackerCD.trackerID ?? UUID(),
                                     trackerName: trackerCD.trackerName ?? "default",
                                     color: uiColorMarshalling.color(from: trackerCD.color ?? "#FFFFF"),
                                     emoji: trackerCD.emoji ?? "x",
                                     schedule: [])
            return newTracker
        }
    }
    
    func purgeTrackers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete all instances of Tracker: \(error)")
        }
    }
    
    func printAllTrackers() {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let allTrackers = try context.fetch(fetchRequest)
            allTrackers.forEach { tracker in
                print("-")
                print(convertToTracker(tracker))
            }
        }
        catch {
            print("Ошибка распечатки категорий")
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении контекста: \(error)")
            }
        }
    }
}
