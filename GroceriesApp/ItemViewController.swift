//
//  ItemViewController.swift
//  GroceriesApp
//
//  Created by Iddy Magohe on 4/24/16.
//  Copyright © 2016 Iddy Magohe. All rights reserved.
//

import UIKit
import CoreData
class ItemViewController: GenericViewController, UITextFieldDelegate, CDPickerTextFieldDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var itemName: UITextField!
    @IBOutlet var itemQuantity: UITextField!
    
    @IBOutlet var unitPickerTF: UintPickerTF!
        
    //MARK:- DELEGATE: UITextField
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case self.itemName:
            if self.itemName.text == "New Item" {
                self.itemName.text = ""
            }
            break;
            case self.unitPickerTF:
                self.unitPickerTF.performFetch()
                self.unitPickerTF.setSelectedRowForComponent(0)
                break;
        default:
            break;
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let item = self.segueObject as? Item {
            switch textField {
            case self.itemName:
                if self.itemName.text == "" {
                    self.itemName.text = "New Item"
                }
                item.name = self.itemName.text
                break;
                
            case self.itemQuantity:
                if let text = self.itemQuantity.text, floatValue = Float(text){
                    item.quantity = NSNumber(float: floatValue)
                }
                break;
                
            default: break;
            }
        }else{self.done()}
    }
    
    //MARK:- VIEW
    //refreshes the interface using the values of the selected, managed object, provided there is one.
    func refreshInterface(){
        if let item = self.selectedObject as? Item {
            self.itemName.text = item.name
            self.itemQuantity.text = item.quantity?.stringValue
            
            
            self.unitPickerTF.text = item.unit?.name ?? ""
            self.unitPickerTF.selectedTitle = item.unit?.name ?? ""
        }else {
            self.done()
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenBackgroundIsTapped()
        self.itemQuantity.delegate = self
        self.itemName.delegate = self
        //displays a Done button.
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(GenericViewController.done))
        self.navigationItem.rightBarButtonItem = doneButton
        self.unitPickerTF.delegate = self
        self.unitPickerTF.pickerDelegate = self

        // Do any additional setup after loading the view.
    }
    
   
     //* The viewWillAppear function calls refreshInterface whenever the view is about to appear,
     //* which ensures fresh data is visible.
     //* It also shows the keyboard immediately when a new item is being created.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshInterface()
        if self.itemName.text == "New Item" {
            self.itemName.text = ""
            self.itemName.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        CDHelper.saveSharedContext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- DATA
    func validateItem() {
        if let item = self.selectedObject as? Item {
            Item.ensureHomeLocationIsNotNil(item)
            Item.ensureShopLocationIsNotNil(item)
        }else { self.done()}
    }
    
    // MARK: - DELEGATE: CDPickerTextFieldDelegate
    func selectedObject(object: NSManagedObject, changedForPickerTF pickerTF: CDPickerTextField) {
        if let item = self.selectedObject as? Item {
            switch (pickerTF) {
        case self.unitPickerTF:
            if let unit = object as? Unit {
                item.unit = unit
            }
            break; default:
                break;
            }
        } else {self.done()}
        self.refreshInterface()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
