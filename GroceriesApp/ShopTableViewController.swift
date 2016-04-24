//
//  ShopTableViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/23/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData

class ShopTableViewController: CDTableViewController {

    //MARK:- CELL CONFIGURATION
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let item = frc.objectAtIndexPath(indexPath) as? Item {
            var itemName = ""
            if let name = item.name { itemName = " \(name)"}
            
            //Prefix quantity and unit
            if let unit = item.unit?.name {itemName = "\(unit)\(itemName)" }
            if let quantity = item.quantity { itemName = "\(quantity)\(itemName)"}
            
            if let textLabel = cell.textLabel, collected = item.collected {
                textLabel.text = itemName
                cell.accessoryType = .DetailButton
                
                // Color items according to the listed attribute
                if collected.boolValue {
                    cell.accessoryType = .Checkmark
                    textLabel.font = UIFont(name: "Helvetica Neue", size: 16)
                    textLabel.textColor = UIColor(colorLiteralRed: 0.37, green: 0.74, blue: 0.35, alpha: 1)
                    textLabel.attributedText = NSAttributedString(string: itemName, attributes: [NSStrikethroughStyleAttributeName : "1"])
                }else {
                    textLabel.font = UIFont(name: "Helvetica Neue", size: 16)
                    textLabel.textColor = UIColor(colorLiteralRed: 1, green: 0.2, blue: 0.2, alpha: 1)
                    textLabel.attributedText = NSAttributedString(string: itemName, attributes: [NSStrikethroughStyleAttributeName : "0"])
                }
            }else { print("ERROR getting textLabel in \(#function)")}
        }else { print("ERROR getting item in \(#function)")}
    }
    //MARK:- INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //CDTableViewCOntroller subclass customization
        self.entity = "Item"
        self.sort = [NSSortDescriptor(key: "locationAtShop.aisle", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        self.sectionNameKeyPath = "locationAtShop.aisle"
        self.fetchBatchSize = 50
        
        if let template = CDHelper.shared.model.fetchRequestTemplateForName("ShoppingList"){
            let request = template as NSFetchRequest
            self.filter = request.predicate
            
        }else { print("Could not find a fetch request template called ShoppingList")}
    }
    
    //MARK: - VIEW
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performFetch()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Add/Remove items from shopping list
        if let item = self.frc.objectAtIndexPath(indexPath) as? Item, collected = item.collected {
            if collected.boolValue {
                item.collected = NSNumber(bool: false)
            }else {
                item.collected = NSNumber(bool: true)
                //item.listed = NSNumber(bool: false)
            }
            CDHelper.saveSharedContext()
        }
        
    }
    
    @IBAction func clear (sender: AnyObject){
        if let items = self.frc.fetchedObjects as? [Item] {
            var nothingChanged = true
            
            // Alert if there are no listed items
            if items.count == 0 {
                
                // ALERT NOTIFICATION
                let alert = UIAlertController(title: "Nothing to Clear", message: "Add items using the Prepare tab", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style:.Default, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            // Clear collected items
            for item in items {
                if let collected = item.collected where collected.boolValue{
                    item.listed = NSNumber(bool: false)
                    item.collected = NSNumber(bool: false)
                    nothingChanged = false
                }
            }
            
            // Alert if there are no collected items
            if nothingChanged {
                let alert = UIAlertController(title: "Nothing to Clear", message: "Select items to be removed from the list before pressing Clear", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style:.Default, handler: nil)
                
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        CDHelper.saveSharedContext()
    }

}
