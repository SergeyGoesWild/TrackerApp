//
//  TrackerStructures.swift
//  Tracker
//
//  Created by Sergey Telnov on 12/11/2024.
//

import Foundation
import UIKit

struct Tracker {
    let trackerID: UUID
    let trackerName: String
    let color: UIColor
    let emoji: String
    let schedule: [String]?
}

struct TrackerCategory {
    let categoryTitle: String
    let categoryTrackers: [Tracker]
}

struct TrackerRecord {
    let recordID: UUID
    let dateComplete: Date
}

//extension TrackerCoreData {
//    var toTracker: Tracker {
//        Tracker(trackerID: trackerID ?? UUID(), trackerName: trackerName ?? "name default", color: UIColorMarshalling().color(from: color ?? ""), emoji: emoji ?? "emoji", schedule: nil)
//    }
//}
//
//extension TrackerCategoryCoreData {
//    var toCategory: TrackerCategory {
//        let theTrackers = Array(trackers as! Set<TrackerCoreData>).map({ $0.toTracker })
//        return TrackerCategory(categoryTitle: categoryTitle ?? "By default", categoryTrackers: theTrackers)
//    }
//}
