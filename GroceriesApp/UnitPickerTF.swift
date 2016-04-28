//
//  UnitPickerTF.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/28/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData

class UintPickerTF: CDPickerTextField{
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // CDPickerTextField subclass customization
        self.entity = "Unit"
        self.sort = [NSSortDescriptor(key: "name", ascending: true)]
        self.fetchBatchSize = 10
        self.performFetch()
        self.inputView = self.createInputView()
        self.inputAccessoryView = self.createInputAccessoryView()
    }
    
    
    // MARK: - ROW SELECTION
    func setSelectedRowForComponent (component:Int){
        switch (component){
        case 0:
            switch (picker, selectedTitle, self.frc.fetchedObjects as? [Unit]){
            case (.Some(let _picker), .Some(let selectedTitle), .Some(let units)):
                // Find the row matching the selected title
                var row = 0;
                for (unit) in units {
                    if selectedTitle == unit.name {
                        _picker.selectRow(row, inComponent:component, animated: false)
                        break;
                    }
                    row += 1
                }
            default:
                print("_picker or selectedTitle is nil or fetchedObjects not [Unit]")
            }
            break;
            // Add more cases to support additional picker components
            
        default:
            break;
        
        }
        
    }
    
    // MARK: - DATASOURCE: UIPickerView
    override func pickerView(pickerView: UIPickerView, titleForRow row: Int,forComponent component: Int) -> String? {
        let indexPath = NSIndexPath(forRow: row, inSection: component)
        if let unit = self.frc.objectAtIndexPath(indexPath) as? Unit {
            return unit.name
        }
        return ""
    }

}

