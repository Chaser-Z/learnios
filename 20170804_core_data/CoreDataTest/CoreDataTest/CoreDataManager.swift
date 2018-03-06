//
//  CoreDataManager.swift
//  CoreDataTest
//
//  Created by Jason on 01/08/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    let context: NSManagedObjectContext
    private let psc: NSPersistentStoreCoordinator
    private let model: NSManagedObjectModel
    private let store: NSPersistentStore
    
    private override init() {
        
        //加载NSManagedObjectModel
        let modelName = "TestModel"
        let bundle = Bundle.main
        let modelURL = bundle.url(forResource: modelName, withExtension: "momd")
        model = NSManagedObjectModel(contentsOf: modelURL!)!
        
        //创建NSPersistentStoreCoordinator
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        //创建NSManagedObjectContext
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        let documentsURL = self.applicationSupportDirectory
        let storeURL = documentsURL.appendingPathComponent("\(modelName).sqlite")
        
        //自动迁移设置
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]

        do {
            store = try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            print("Failed to add persistent store: \(error)")
            abort()
        }
    }
    
    private var applicationDocumentsDirectory: URL = {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }()
    
    private var applicationSupportDirectory: URL = {
        let fileManager = FileManager.default
        let url = try! fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url
    }()
    //保存上下文
    private func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            print("Failed to save: \(error)")
            abort()
        }
    }
    
}
