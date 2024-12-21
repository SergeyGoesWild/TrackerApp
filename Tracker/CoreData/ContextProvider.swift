//
//  PersistentContainerProvider.swift
//  Tracker
//
//  Created by Sergey Telnov on 21/12/2024.
//

import Foundation
import CoreData

final class ContextProvider {
    static let shared = ContextProvider()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
}
