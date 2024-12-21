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
    var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
    init(trackerStore: TrackerStore) {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    
    func getAllPossibleTitles() -> [String] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let allCategories = try context.fetch(fetchRequest)
            var allPossibleTitles: [String] = []
            for category in allCategories {
                if let title = category.categoryTitle {
                    allPossibleTitles.append(title)
                }
            }
            return allPossibleTitles
        } catch {
            print("Ошибка при получении категории: \(error)")
            return []
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
            guard let trackersSet = trackerCategory.trackers as? Set<TrackerCoreData> else { return }
            let convertedTrackers = trackersSet.map { trackerCoreData in
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
