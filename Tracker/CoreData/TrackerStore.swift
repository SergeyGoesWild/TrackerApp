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
        saveContext()
        return newTracker
    }
    
    func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Ошибка при получении трекера по ID: \(error)")
            return nil
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
