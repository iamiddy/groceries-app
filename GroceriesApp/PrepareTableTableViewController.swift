//
//  PrepareTableTableViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/20/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData

class PrepareTableTableViewController: CDTableViewController {
    
    //MARK:- CELL CONFIGURATION
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let item = frc.objectAtIndexPath(indexPath) as? Item {
            var itemName = ""
            if let name = item.name { itemName = " \(name)"}
            
            //Prefix quantity and unit
            if let unit = item.unit?.name {itemName = "\(unit)\(itemName)" }
            if let quantity = item.quantity { itemName = "\(quantity)\(itemName)"}
            
            if let textLabel = cell.textLabel, listed = item.listed {
                textLabel.text = itemName
                cell.accessoryType = .DetailButton
                
                // Color items according to the listed attribute
                if listed.boolValue {
                    textLabel.font = UIFont(name: "Helvetica Neue", size: 18)
                    textLabel.textColor = UIColor(colorLiteralRed: 1, green: 0.2, blue: 0.2, alpha: 1)
                }else {
                    textLabel.font = UIFont(name: "Helvetica Neue", size: 16)
                    textLabel.textColor = UIColor.grayColor()
                }
            }else { print("ERROR getting textLabel in \(#function)")}
        }else { print("ERROR getting item in \(#function)")}
    }
    
    //MARK:- INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //CDTableViewCOntroller subclass customization
        self.entity = "Item"
        self.sort = [NSSortDescriptor(key: "locationAtHome.storedIn", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        self.sectionNameKeyPath = "locationAtHome.storedIn"
        self.fetchBatchSize = 50
    }
    
    //MARK: - VIEW 
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performFetch()
    }
    
    //MARK:- DATA SOURCE: UITable
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            if let object = self.frc.objectAtIndexPath(indexPath) as? NSManagedObject{
                self.frc.managedObjectContext.deleteObject(object)
            }
            CDHelper.saveSharedContext()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Add/Remove items from shopping list
        if let item = self.frc.objectAtIndexPath(indexPath) as? Item, listed = item.listed {
            if listed.boolValue {
                item.listed = NSNumber(bool: false)
            }else {
                item.listed = NSNumber(bool: true)
                item.collected = NSNumber(bool: false)
            }
            CDHelper.saveSharedContext()
        }
    
    }
    
    //MARK:- INTERACTION
    @IBAction func clear(sender: AnyObject){
        if let request = CDHelper.shared.model.fetchRequestTemplateForName("ShoppingList"){
            let context = frc.managedObjectContext
            var error: NSError?
            
            let listedItemCount = context.countForFetchRequest(request, error: &error)
            if let _error = error { print("ERROR getting 'ShoppingList' fetch request template: \(_error.localizedDescription)")}
            if listedItemCount > 0{
                //ACTION CONFIRMATION
                let sheet = UIAlertController(title: "Clear Entire Shopping List", message: nil, preferredStyle: .ActionSheet)
                let confirm = UIAlertAction(title: "Clear", style: .Destructive, handler: { (action) in
                    self.clearList()
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                
                sheet.addAction(confirm)
                sheet.addAction(cancel)
                self.presentViewController(sheet, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Nothing to Clear", message: "Add items to the Shop tab by tapping them on the Prepare tab. Remove all items from the Shop tab by clicking Clear on the Prepare tab", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            print("ERROR getting 'ShoppingList' fetch request")
        }
        CDHelper.saveSharedContext()
    }
    
    func clearList(){
        if let request = CDHelper.shared.model.fetchRequestTemplateForName("ShoppingList"){
            let context = frc.managedObjectContext
            context.performBlock {
                do {
                    if let items = try context.executeFetchRequest(request) as? [Item] {
                        for item in items {
                            item.listed = NSNumber(bool: false)
                        }
                    }else {print("\(#function) FAILED to fetch objects")}
                }catch { print("\(#function) FAILED to fetch objects") }
                CDHelper.saveSharedContext()
            }
            
        }else{print("ERROR getting 'ShoppingList' fetch request")}
    }
}
