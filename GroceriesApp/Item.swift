//
//  Item.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/19/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func ensureLocationAreNotNilForAllItems(){
        let predicate = NSPredicate(format: "locationAtHome == nil OR locationAtShop == nil")
        let lostItems = CDOperation.objectsForEntity("Item", context: CDHelper.shared.context, filter: predicate, sort: nil)
        if let items = lostItems as? [Item] {
            for item in items {
                //Assign orphaned items to uknown home/shop location
                ensureHomeLocationIsNotNil(item)
                ensureShopLocationIsNotNil(item)
            }
        }
    }
    

    class func ensureHomeLocationIsNotNil(item:Item){
        guard item.locationAtHome == nil else { return}
        let context = item.managedObjectContext!
        let entity = "LocationAtHome"
        let attribute = "storedIn"
        let value = "? Uknown Location"
        
        if let uknown = CDOperation.objectWithAttributeValueForEntity(entity, context: context, attribute: attribute, value: value) as? LocationAtHome {
            item.locationAtHome = uknown
        }else {
            if let newLocation = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context) as? LocationAtHome {
                newLocation.storedIn = value
                item.locationAtHome = newLocation
            }
        }
    }
    
    class func ensureShopLocationIsNotNil(item:Item){
        guard item.locationAtShop == nil else { return}
        let context = item.managedObjectContext!
        let entity = "LocationAtShop"
        let attribute = "aisle"
        let value = "? Uknown Location"
        
        if let uknown = CDOperation.objectWithAttributeValueForEntity(entity, context: context, attribute: attribute, value: value) as? LocationAtShop {
            item.locationAtShop = uknown
        }else {
            if let newLocation = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context) as? LocationAtShop {
                newLocation.aisle = value
                item.locationAtShop = newLocation
            }
        }
    }
}
