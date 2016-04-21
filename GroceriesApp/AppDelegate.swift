//
//  AppDelegate.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/18/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Debug -com.apple.CoreData.SQLDebug 3
    
    func demo(){
      //  loadMeasurementsSamples()
        //fetch50Measurements()
      //  fetch50Amounts()
       // fetch50Unit ()
        //CDHelper.shared
       // insertCoupleItems()
        CDOperation.objectCountForEntity("Item", context: CDHelper.shared.context)
        CDOperation.objectCountForEntity("Unit", context: CDHelper.shared.context)
        
    }
    
    func insertCoupleItems(){
        let context = CDHelper.shared.context
        if let kg = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: context) as? Unit ,
            let oranges = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as? Item ,
            let bananas = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as? Item {
            
            kg.name = "Kg"
            oranges.name = "Oranges"
            bananas.name = "Bananas"
            oranges.quantity = NSNumber(float: 1)
            bananas.quantity = NSNumber(float: 4)
            oranges.listed = NSNumber(bool: true)
            bananas.listed = NSNumber(bool: true)
            oranges.unit = kg
            bananas.unit = kg
            
            print("Inserted \(oranges.quantity!) \(oranges.unit!.name!) of \(oranges.name!)")
            print("Inserted \(bananas.quantity!) \(bananas.unit!.name!) of \(bananas.name!)")
            
            CDHelper.saveSharedContext()

        }
        
        
        
    }
    
    func fetch50Unit () {
        let context = CDHelper.shared.context
        let request = NSFetchRequest(entityName: "Unit")
        request.fetchLimit = 50
        do {
            if let units = try context.executeFetchRequest(request) as? [Unit] {
                for unit in units {
                    print("Fetched Unit Object \(unit.name!)")
                } }
        } catch {
            print("ERROR executing a fetch request: \(error)")
        }
    }
    
    func demo_delete(){
        
        let context = CDHelper.shared.context
        let request = NSFetchRequest(entityName: "Item")
        
        
        do{
            if let items =  try CDHelper.shared.context.executeFetchRequest(request) as? [Item] {
                for item in items {
                    print("Deleting Item = \(item.name!)")
                    context.deleteObject(item)
                }
            }
        }catch{
            print("Error executing fetchRequest: \(error)")
        }
        CDHelper.saveSharedContext()
    }
    func fetch50Amounts(){
        let context = CDHelper.shared.context
        let request = NSFetchRequest(entityName: "Amount")
        let sort = NSSortDescriptor(key: "xyz", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchOffset = 0
        request.fetchLimit = 50
        
        do{
            if let amounts = try context.executeFetchRequest(request) as? [Amount]{
                for a in amounts {
                    print("Fetched Amount Object \(a.xyz!)")
                }
                
            }
        }catch{ print("ERROR executing fetch request: \(error)")}
    }
    
    func fetch50Measurements(){
        let context = CDHelper.shared.context
        let request = NSFetchRequest(entityName: "Measurement")
         let sort = NSSortDescriptor(key: "abc", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchOffset = 0
        request.fetchLimit = 50
        
        do{
            if let measurements = try context.executeFetchRequest(request) as? [Measurement]{
                for m in measurements {
                    print("Fetched Measurement Object \(m.abc!)")
                }
                
            }
        }catch{ print("ERROR executing fetch request: \(error)")}
    }
    
    func loadMeasurementsSamples(){
        let conetx = CDHelper.shared.context
        
        for i in 0...5000 {
            if let newMeasurement = NSEntityDescription.insertNewObjectForEntityForName("Measurement", inManagedObjectContext: conetx) as? Measurement{
                newMeasurement.abc = "-->> LOTS OF TEST DATA x\(i)"
                print("Inserted \(newMeasurement.abc)")
            }
        }
    }
    
    func demo_fetchTemplate(){
        let model = CDHelper.shared.model
        if let template = model.fetchRequestTemplateForName("Test"),
            let request = template.copy() as? NSFetchRequest{
            
                let sort = NSSortDescriptor(key: "name", ascending: true)
                request.sortDescriptors = [sort]
                do{
                    if let items =  try CDHelper.shared.context.executeFetchRequest(request) as? [Item] {
                        for item in items {
                            print("Fetched Managed Object = \(item.name!)")
                        }
                    }
                }catch{ print("Error executing fetchRequest: \(error)") }
        }else{ print("FAILED to prepare template")}
    }
    
    func demo_withoutTemplate(){
        let request = NSFetchRequest(entityName: "Item")
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        let filter = NSPredicate(format: "name != %@", "Coffee")
        request.predicate = filter
        
        do{
            if let items =  try CDHelper.shared.context.executeFetchRequest(request) as? [Item] {
                for item in items {
                    print("Fetched Managed Object = \(item.name!)")
                }
            }
        }catch{
            print("Error executing fetchRequest: \(error)")
        }
    }
    
    func dem0(){
        let itemNames = ["Apples", "Milk", "Bread", "Cheese", "Sausages", "Orange Juice", "Cereal", "Coffee", "Eggs", "Tomatoes", "Fish", "Butter"]
        
        for itemName in itemNames {
            if let item:Item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: CDHelper.shared.context) as? Item {
                item.name = itemName
                print("Inserted New Managed Object for '\(item.name!)'")
            }
        }
        CDHelper.saveSharedContext()
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
       // CDHelper.shared
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CDHelper.saveSharedContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      //  demo()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       // self.saveContext()
         CDHelper.saveSharedContext()
    }

//    // MARK: - Core Data stack
//
//    lazy var applicationDocumentsDirectory: NSURL = {
//        // The directory the application uses to store the Core Data store file. This code uses a directory named "iddy85-gmail.com.GroceriesApp" in the application's documents Application Support directory.
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        return urls[urls.count-1]
//    }()
//
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
//        let modelURL = NSBundle.mainBundle().URLForResource("GroceriesApp", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//    }()
//
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
//        // Create the coordinator and store
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
//        var failureReason = "There was an error creating or loading the application's saved data."
//        do {
//            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
//        } catch {
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//
//            dict[NSUnderlyingErrorKey] = error as NSError
//            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            // Replace this with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
//            abort()
//        }
//        
//        return coordinator
//    }()
//
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
//        let coordinator = self.persistentStoreCoordinator
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = coordinator
//        return managedObjectContext
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        if managedObjectContext.hasChanges {
//            do {
//                try managedObjectContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                abort()
//            }
//        }
//    }

}

