//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Sergey Telnov on 05/12/2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    private var trackerStore: TrackerStore
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context, trackerStore: TrackerStore(context: context))
    }

    init(context: NSManagedObjectContext, trackerStore: TrackerStore) {
        self.context = context
        self.trackerStore = trackerStore
    }
    
    func createTrackerCategory(categoryTitle: String) {
        let trackerCategory = TrackerCategoryCoreData(context: context)
        trackerCategory.categoryTitle = categoryTitle
        saveContext()
    }
    
    func updateTrackerCategory(title: String, newTracker: Tracker) {
        if let trackerCategory = fetchTrackerCategory(by: title) {
            let newTrackerCD = trackerStore.createTracker(newTracker)
            trackerCategory.addToTrackers(newTrackerCD)
            saveContext()
        }
    }
    
    func fetchTrackerCategory(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryTitle == %@", title as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Ошибка при получении категории: \(error)")
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
