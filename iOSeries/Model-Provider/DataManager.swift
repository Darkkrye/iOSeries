//
//  DataManager.swift
//  iOSeries
//
//  Created by Pierre on 14/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import Foundation
import CoreData

class DataManager: NSObject {
    public static let shared = DataManager()
    
    public var objectContext: NSManagedObjectContext? = nil
    
    private override init() {
        // Création du schéma de la base de données
        if let modelURL = Bundle.main.url(forResource: "iOSeries", withExtension: "momd") {
            if let model = NSManagedObjectModel(contentsOf: modelURL) {
                if let storageURL = FileManager.documentURL(childPath: "iOSeries.db") {
                    
                    let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                    
                    _ = try? storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storageURL, options: nil)
                    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    context.persistentStoreCoordinator = storeCoordinator
                    
                    self.objectContext = context
                }
            }
        }
    }
}
