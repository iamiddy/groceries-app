//
//  CDOperation.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/20/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import Foundation
import CoreData

class CDOperation {
    class func objectCountForEntity(entityName: String, context: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest(entityName: entityName)
        var error:NSError?
        let count = context.countForFetchRequest(request, error: &error )
        if let _error = error {
            print("\(#function) Error: \(_error.localizedDescription)")
        }else{
            print("There are \(count) \(entityName) object(s) in \(context)")
        }
        return count
    }
}
