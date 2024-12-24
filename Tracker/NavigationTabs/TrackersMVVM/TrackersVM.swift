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
            onCategoriesUpdated?(categoriesVisible)
        }
    }
    
    var onCategoriesUpdated: (([TrackerCategory]) -> Void)?
    var dataProvider: DataProvider!
    var currentDate: Date!
    var currentDay: String!
    let colorConverter = UIColorMarshalling()
    
    init() {
        dataProvider = DataProvider()
        fetchByDay(dayOfWeek: currentDay)
    }
    
    func fetchByDay(dayOfWeek: String) {
        dataProvider.performFetchByDay(for: dayOfWeek)
        fetchCategories()
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
