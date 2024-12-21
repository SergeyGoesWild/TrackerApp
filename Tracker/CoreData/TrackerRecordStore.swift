//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Sergey Telnov on 12/12/2024.
//

import Foundation
import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    
    convenience init() {
        let context = ContextProvider.shared.context
        self.init(context: context, trackerStore: TrackerStore(context: context))
    }
    
    init(context: NSManagedObjectContext, trackerStore: TrackerStore) {
        self.context = context
        self.trackerStore = trackerStore
    }
    
    func createRecord(_ trackerID: UUID, _ date: Date) {
        guard let tracker = trackerStore.fetchTracker(by: trackerID) else {
            print("Error: Tracker with ID \(trackerID) not found.")
            return
        }
        
        let newTrackerRecordCoreData = TrackerRecordCoreData(context: context)
        newTrackerRecordCoreData.dateComplete = date
        newTrackerRecordCoreData.tracker = tracker
        saveContext()
    }
    
    func checkIfRecordExist(_ id: UUID, _ date: Date) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.trackerID == %@ AND dateComplete == %@", id as CVarArg, date as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch Tracker with ID \(id) and Date \(date): \(error)")
            return false
        }
    }
    
    func getCompleteDays(_ id: UUID) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.trackerID == %@", id as CVarArg)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print(error)
            return 0
        }
    }
    
    func deleteRecord(withID id: UUID, on date: Date) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.trackerID == %@ AND dateComplete == %@", id as CVarArg, date as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let trackerToDelete = results.first {
                context.delete(trackerToDelete)
                try context.save()
            } else {
                print("No tracker found with the given ID.")
            }
        } catch {
            throw error
        }
    }
    
    func purgeTrackerRecords() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete all instances of TrackerRecords: \(error)")
        }
    }
    
    func printAllRecords() {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let allRecords = try context.fetch(fetchRequest)
            allRecords.forEach { record in
                print("->", record)
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

