//
//  Unit+CoreDataProperties.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/20/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Unit {

    @NSManaged var name: String?
    @NSManaged var items: NSSet?

}
