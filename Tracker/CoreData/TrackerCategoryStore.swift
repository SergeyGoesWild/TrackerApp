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
    var trackerStore: TrackerStore
    
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
    
    func fetchTrackerCategoryForDay(by dayOfWeek: String) -> [TrackerCategoryCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let allCategories = try context.fetch(fetchRequest)
            var filteredCategories: [TrackerCategoryCoreData] = []
            
            for currentCategory in allCategories {
                // Safely access the trackers relationship
                if let trackers = currentCategory.trackers as? Set<TrackerCoreData> {
                    // Filter the trackers that match the criteria
                    let matchingTrackers = trackers.filter { tracker in
                        if let scheduleUnits = tracker.schedule as? Set<ScheduleUnit> {
                            return scheduleUnits.contains { $0.value == dayOfWeek }
                        }
                        return false
                    }
                    
                    // Only include the category if there are matching trackers
                    if !matchingTrackers.isEmpty {
                        // Replace the current category's trackers with only the matching trackers
                        currentCategory.trackers = NSSet(set: matchingTrackers)
                        filteredCategories.append(currentCategory)
                    }
                }
            }
            return filteredCategories
            
        } catch {
            print("Ошибка при получении категории: \(error)")
            return []
        }
    }
    
    func printAllCategories() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let allCategories = try context.fetch(fetchRequest)
            let allCategoriesConverted = convertToCategory(allCategories)
            allCategoriesConverted.forEach { category in
                print(category)
            }
        }
        catch {
            print("Ошибка распечатки категорий")
        }
    }
    
    func convertToCategory(_ trackerCategoryCD: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        var convertedCategory: [TrackerCategory] = []
        trackerCategoryCD.forEach { trackerCategory in
            let convertedTrackers = Array(trackerCategory.trackers as! Set<TrackerCoreData>).map { trackerCoreData in
                // Use the TrackerStore method to convert TrackerCoreData to Tracker
                return trackerStore.convertToTracker(trackerCoreData)
            }
            let newCategory = TrackerCategory(categoryTitle: trackerCategory.categoryTitle ?? "default", categoryTrackers: convertedTrackers)
            convertedCategory.append(newCategory)
        }
        
        return convertedCategory
    }
    
    func purgeTrackerCategories() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete all instances of TrackerCategory: \(error)")
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
