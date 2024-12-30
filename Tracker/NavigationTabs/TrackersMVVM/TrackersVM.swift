//
//  TrackersVM.swift
//  Tracker
//
//  Created by Sergey Telnov on 24/12/2024.
//

import Foundation

class TrackersVM {
    private(set) var categoriesVisible: [TrackerCategory] = [] {
        didSet {
            onCategoriesUpdated?()
        }
    }
    
    var defaultCategory: [String] = ["Важные дела"]
    var onCategoriesUpdated: (() -> Void)?
    var dataProvider: DataProvider!
    let colorConverter = UIColorMarshalling()
    
    init() {
        dataProvider = DataProvider()
    }
    
    func fetchByDay(dayOfWeek: String) {
        dataProvider.performFetchByDay(for: dayOfWeek)
        fetchCategories()
    }
    
    func getAllPossibleTitles() -> [String] {
        let allPossibleTitles = dataProvider.getAllPossibleTitles()
        if allPossibleTitles.contains(where: {$0 == defaultCategory[0]}) {
            return allPossibleTitles
        } else {
            return allPossibleTitles + defaultCategory
        }
    }
    
    func didReceiveNewTracker(newTrackerCategory: TrackerCategory) {
        if dataProvider.fetchTrackerCategory(by: newTrackerCategory.categoryTitle) != nil {
            dataProvider.updateTrackerCategory(title: newTrackerCategory.categoryTitle, newTracker: newTrackerCategory.categoryTrackers[0])
        }
        else {
            dataProvider.createTrackerCategory(categoryTitle: newTrackerCategory.categoryTitle)
            dataProvider.updateTrackerCategory(title: newTrackerCategory.categoryTitle, newTracker: newTrackerCategory.categoryTrackers[0])
        }
    }
    
    func checkRecordExist(with id: UUID, at currentDate: Date) -> Bool {
        return dataProvider.checkRecordExist(with: id, at: currentDate)
    }
    
    func isTrackerCompleteCurrentDate(id: UUID, at currentDate: Date) -> Bool {
        return dataProvider.checkRecordExist(with: id, at: currentDate)
    }
    
    func getCompleteDays(for id: UUID) -> Int {
        return dataProvider.getCompleteDays(for: id)
    }
    
    func completeTracker(id: UUID, date: Date){
        dataProvider.createRecord(with: id, for: date)
    }
    
    func uncompleteTracker(id: UUID, date: Date){
        dataProvider.deleteRecord(with: id, for: date)
    }
    
    private func fetchCategories() {
        let grouped = Dictionary(grouping: dataProvider.results) { $0.category?.categoryTitle ?? "Unknown Category" }
        
        categoriesVisible = grouped.map { categoryName, trackers in
            TrackerCategory(
                categoryTitle: categoryName,
                categoryTrackers: trackers.map { tracker in
                    let scheduleSet = tracker.schedule as? Set<ScheduleUnit>
                    let newSchedule = scheduleSet?.compactMap { $0.value }
                    return Tracker(
                        trackerID: tracker.trackerID ?? UUID(),
                        trackerName: tracker.trackerName ?? "",
                        color: colorConverter.color(from: tracker.color ?? "#FFFFFF"),
                        emoji: tracker.emoji ?? "",
                        schedule: newSchedule ?? []
                    )
                }
            )
        }
    }
}
