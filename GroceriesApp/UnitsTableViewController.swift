//
//  UnitsViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/27/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData

class UnitsTableViewController: CDTableViewController {
    
    //MARK:- CELL CONFIGURATION
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
       cell.accessoryType = .None
        if let unit = self.frc.objectAtIndexPath(indexPath) as? Unit {
            if let textLabel = cell.textLabel {
                textLabel.text = unit.name
            }
        }
    }
    
    //MARK:- INITIALIZATION
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // CDTAbleViewController subclass customization
        self.entity = "Unit"
        self.sort = [NSSortDescriptor(key: "name", ascending: true)]
        self.fetchBatchSize = 50
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Units"
        self.performFetch()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- DATA SOURCE: UITableView
    // MARK: - DATA SOURCE: UITableView
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let object = self.frc.objectAtIndexPath(indexPath) as? NSManagedObject {
            self.frc.managedObjectContext.deleteObject(object)
        }
        CDHelper.saveSharedContext()
    }
    // MARK: - INTERACTION
    @IBAction func done (sender: AnyObject) {
        if let parent = self.parentViewController {
            parent.dismissViewControllerAnimated(true, completion: nil)
        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let unitVC = segue.destinationViewController as? UnitViewController {
            if segue.identifier == "Add Object Segue" {
                let object = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: CDHelper.shared.context)
                unitVC.segueObject = object
            }else {
                if segue.identifier == "Edit Object Segue" {
                    if let indexpath = self.tableView.indexPathForSelectedRow {
                        if let object = self.frc.objectAtIndexPath(indexpath) as? NSManagedObject{
                            unitVC.segueObject = object
                        }
                    }
                }else { print ("Unidentified Segue Attempted!")}
            }
        }
    }
   

}
