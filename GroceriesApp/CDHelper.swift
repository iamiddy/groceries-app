//
//  CDHelper.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/18/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import Foundation
import CoreData

private let _sharedCDHelper = CDHelper()
class CDHelper: NSObject{
    
    //MARK: - SHARED INSTANCE
    class var shared: CDHelper {
        return _sharedCDHelper
    }
    
    //MARK: - SETUP
    required override init() {
        super.init()
        self.setupCoreData()
    }
    
    func setupCoreData(){
        // Model Migration
        if let _localStoreURL = self.localStoreURL {
            CDMigration.shared.migrateStoreIfNecessary(_localStoreURL, destinationModel: self.model)
        }

        _ = self.localStore
    }
    
    //MARK: - PATHS
    lazy var storesDirectory: NSURL? = {
        let fm = NSFileManager.defaultManager()
        let urls = fm.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    lazy var localStoreURL: NSURL? = {
        if let url = self.storesDirectory?.URLByAppendingPathComponent("LocalStore.sqlite"){
            print("localStoreURL = \(url)")
            return url
        }
        return nil
    }()
    lazy var modelURL: NSURL = {
        let bundle = NSBundle.mainBundle()
        if let url = bundle.URLForResource("Model", withExtension: "momd"){
            return url
        }
        print("CRITICAL - Managed Object Model file not found")
        abort()
    }()
    
    //MARK: - CONTEXT
    lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.coordinator
        return moc
    }()
    
    //MARK: - MODEL
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL:self.modelURL)!
    }()
    
    //MARK: - COORDINATOR
    lazy var coordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel:self.model)
    }()
    
    //MARK: - STORE
    lazy var localStore: NSPersistentStore? = {
        let useMigrationManager = true
        if let _localStoreURL = self.localStoreURL {
            if useMigrationManager == true && CDMigration.shared.storeExistsAtPath(_localStoreURL) && CDMigration.shared.store(_localStoreURL, isCompatibleWithModel:
                self.model) == false {
                return nil // Don't return a store if it's not compatible with the model
            } }

        let options:[NSObject:AnyObject] = [NSSQLitePragmasOption:["journal_mode":"DELETE"], NSMigratePersistentStoresAutomaticallyOption:0, NSInferMappingModelAutomaticallyOption:0] // 1,default infer 1
        var _localStore:NSPersistentStore?
        do{
            _localStore = try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.localStoreURL, options: options)
            return _localStore
        }catch{
            return nil
        }
        
    }()
   
    // MARK: - SAVING
    class func save(moc:NSManagedObjectContext) {
         moc.performBlockAndWait {
            if moc.hasChanges {
                do {
                    try moc.save()
                    print("SAVED context \(moc.description)")
                }catch {
                    print("ERROR saving context \(moc.description) - \(error)")
                }
            }else {
                print("SKIPPED saving context \(moc.description) because there are no changes")
            }
            if let parentContext = moc.parentContext {
                save(parentContext)
            }
        }
    }
    
    class func saveSharedContext(){
        save(shared.context)
    }
}
