//
//  Item+CoreDataProperties.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/23/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var collected: NSNumber?
    @NSManaged var listed: NSNumber?
    @NSManaged var name: String?
    @NSManaged var photoData: NSData?
    @NSManaged var quantity: NSNumber?
    @NSManaged var unit: Unit?
    @NSManaged var locationAtHome: LocationAtHome?
    @NSManaged var locationAtShop: LocationAtShop?

}
