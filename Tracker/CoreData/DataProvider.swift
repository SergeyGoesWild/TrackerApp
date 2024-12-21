//
//  DataProvider.swift
//  Tracker
//
//  Created by Sergey Telnov on 20/12/2024.
//

import Foundation
import UIKit
import CoreData

final class DataProvider: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    let trackerStore: TrackerStore
    let trackerCategoryStore: TrackerCategoryStore
    let trackerRecordStore: TrackerRecordStore
    private weak var trackerCollection: UICollectionView?
    var onContentChanged: (() -> Void)?
    
    init(trackerCollection: UICollectionView) {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.trackerStore = TrackerStore()
        self.trackerCategoryStore = TrackerCategoryStore(trackerStore: self.trackerStore)
        self.trackerRecordStore = TrackerRecordStore()
        self.trackerCollection = trackerCollection
        super.init()
        setupFetchedResultsController()
    }

    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.categoryTitle", ascending: true),
            NSSortDescriptor(key: "trackerName", ascending: true)
        ]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.categoryTitle",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
    }
    
    //MARK: FetchedResultsController methods
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }
    
    func performFetchByDay(for dayOfWeek: String) {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "ANY schedule.value == %@", dayOfWeek
        )
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to update fetch request: \(error)")
        }
    }
    
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func numberOfItems(inSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func category(for sectionIndex: Int) -> String? {
        guard let sections = fetchedResultsController.sections,
              sectionIndex < sections.count else {
            return nil
        }
        let firstObject = fetchedResultsController.object(at: IndexPath(row: 0, section: sectionIndex))
        guard let category = firstObject.category else { return nil }
        return category.categoryTitle
    }
    
    func object(at indexPath: IndexPath) -> Tracker {
        return trackerStore.convertToTracker(fetchedResultsController.object(at: indexPath))
    }
    
    func purgeAllData() {
        trackerCategoryStore.purgeTrackerCategories()
        trackerCategoryStore.trackerStore.purgeTrackers()
        trackerRecordStore.purgeTrackerRecords()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onContentChanged?()
    }
    
    //MARK: Tracker methods
    func createTracker(tracker: Tracker) -> TrackerCoreData {
       return trackerStore.createTracker(tracker)
    }
    
    func fetchTracker(by id: UUID) -> TrackerCoreData? {
        return trackerStore.fetchTracker(by: id)
    }
    
    //MARK: TrackerCategory methods
    func createTrackerCategory(categoryTitle: String) {
        trackerCategoryStore.createTrackerCategory(categoryTitle: categoryTitle)
    }
    
    func updateTrackerCategory(title: String, newTracker: Tracker) {
        trackerCategoryStore.updateTrackerCategory(title: title, newTracker: newTracker)
    }
    
    func getAllPossibleTitles() -> [String] {
        return trackerCategoryStore.getAllPossibleTitles()
    }
    
    func fetchTrackerCategory(by title: String) -> TrackerCategoryCoreData? {
        return trackerCategoryStore.fetchTrackerCategory(by: title)
    }
    
    //MARK: Record methods
    func createRecord(with id: UUID, for date: Date) {
        trackerRecordStore.createRecord(id, date)
    }
    
    func deleteRecord(with id: UUID, for date: Date) throws {
        do {
            try trackerRecordStore.deleteRecord(withID: id, on: date)
        }
        catch {
            print(error)
        }
    }
    
    func checkRecordExist(with id: UUID, at date: Date) -> Bool {
        return trackerRecordStore.checkIfRecordExist(id, date)
    }
    
    func getCompleteDays(for id: UUID) -> Int {
        return trackerRecordStore.getCompleteDays(id)
    }
}

extension DataProvider: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        let indexSet = IndexSet(integer: sectionIndex)
        guard let trackerCollection else { return }
        switch type {
        case .insert:
            trackerCollection.insertSections(indexSet)
           
        case .delete:
            if let indexPath = indexPath {
                trackerCollection.deleteItems(at: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                trackerCollection.reloadItems(at: [indexPath])
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                trackerCollection.moveItem(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            fatalError("Unknown change type in NSFetchedResultsControllerDelegate.")
        }
    }
}
