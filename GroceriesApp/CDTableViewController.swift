//
//  CDTableViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/22/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData

class CDTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - CELL CONFIGURATION
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath){
        // Use self.arc.objectAtIndexPath(indexPath) to get an object specific to a cell in a subclass
        print("please override configureCell in \(#function)!")
        
    }
    
    // override
    var entity = "MyEntity"
    var sort = [NSSortDescriptor(key: "myAttribute", ascending: true)]
    
    //Optionally Override
    var context = CDHelper.shared.context
    var filter: NSPredicate? = nil
    var cacheName:String? = nil
    var sectionNameKeyPath:String? = nil
    var fetchBatchSize = 0 // 0 = No Limit
    var cellIdentifier = "Cell"
    
    //MARK: - FETCHED RESULTS CONTROLLER
    lazy var frc: NSFetchedResultsController = {
        let request: NSFetchRequest = NSFetchRequest(entityName: self.entity)
        request.sortDescriptors = self.sort
        request.fetchBatchSize = self.fetchBatchSize
        if let _filter = self.filter {request.predicate = _filter}
        
        let newFRC: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request,managedObjectContext: self.context,sectionNameKeyPath: self.sectionNameKeyPath,cacheName: self.cacheName)
        newFRC.delegate = self
        return newFRC
    }()
    
    
    //MARK: - FETCH
    func performFetch(){
        self.frc.managedObjectContext.performBlock({
            do {
                try self.frc.performFetch()
            }catch{
                print("\(#function) FAILED : \(error)")
            }
            self.tableView.reloadData()
        })
    }
    
    
    //MARK: - VIEW
    override func viewDidLoad() {
        super.viewDidLoad()
        //Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDTableViewController.performFetch), name: "SomethingChanged", object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.frc.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.frc.sections![section].numberOfObjects ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: self.cellIdentifier)
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        cell!.accessoryType = UITableViewCellAccessoryType.DetailButton
        self.configureCell(cell!, atIndexPath: indexPath)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.frc.sectionForSectionIndexTitle(title, atIndex: index)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.frc.sections![section].name ?? " "
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return frc.sectionIndexTitles
    }
    
    //MARK:- DELEGATE: NSFetchresultsController
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
   //MARK: - DEALLOCATION
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "performfetch", object: nil)
    }
    
}
